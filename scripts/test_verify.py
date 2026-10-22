"""Regression controls for acceptance failures; no Lean installation is needed."""
import importlib.util
import json
from pathlib import Path
import subprocess
import sys
import tempfile
from types import SimpleNamespace
import unittest
from unittest.mock import patch

SCRIPT = Path(__file__).with_name('verify.py')
spec = importlib.util.spec_from_file_location('standalone_verify', SCRIPT)
verify = importlib.util.module_from_spec(spec)
spec.loader.exec_module(verify)


class VerificationControls(unittest.TestCase):
    def test_clean_plain_and_json_information(self):
        verify.check_diagnostics('Build completed successfully.\n')
        verify.check_diagnostics(json.dumps({'severity': 'information', 'data': 'checked'}),
                                 json_mode=True)

    def test_native_and_plain_diagnostic_rejection(self):
        for text in ['PANIC at kernel', 'panic: kernel', 'error: fixture',
                     'file.lean:3:2: warning: fixture']:
            with self.subTest(text=text), self.assertRaises(AssertionError):
                verify.check_diagnostics(text)

    def test_json_failures_rejected(self):
        for obj in [{'severity': 'error', 'data': 'fixture'},
                    {'severity': 'warning', 'data': 'fixture'},
                    {'severity': 'information', 'data': 'PANIC at kernel'},
                    {'severity': 'information', 'data': 'error: fixture'},
                    {'error': 'unrecognized diagnostic'},
                    {'severity': 'fatal', 'data': 'fixture'},
                    {'severity': 'information'}, []]:
            with self.subTest(obj=obj), self.assertRaises(AssertionError):
                verify.check_diagnostics(json.dumps(obj), json_mode=True)
        with self.assertRaises(AssertionError):
            verify.check_diagnostics('{"severity":"error"')
        with self.assertRaises(AssertionError):
            verify.check_diagnostics('unstructured output', json_mode=True)

    def test_every_import_is_returned(self):
        text = ('/- import Ignored.Comment -/\n'
                '  public import Mathlib.Data.Bool.Basic Private.Hidden\n'
                'import\n  Mathlib.Data.Nat.Basic\n  Private.Multiline\n'
                'namespace X\ndef s := "import Ignored.String"\nend X\n')
        self.assertEqual(verify.imported_modules(text),
                         ['Mathlib.Data.Bool.Basic', 'Private.Hidden',
                          'Mathlib.Data.Nat.Basic', 'Private.Multiline'])

    def test_unsupported_import_fails_closed(self):
        for text in ['import «Unsupported»', 'import\nnamespace X\nend X']:
            with self.subTest(text=text), self.assertRaises(AssertionError):
                verify.imported_modules(text)

    def test_optimized_python_refused(self):
        result = subprocess.run([sys.executable, '-O', str(SCRIPT), '--help'],
                                text=True, capture_output=True)
        self.assertNotEqual(result.returncode, 0)
        self.assertIn('requires enabled Python assertions', result.stderr)

    def test_zero_exit_exact_build_error_rejected_end_to_end(self):
        config = json.loads((SCRIPT.parent.parent / 'verification.json').read_text())

        def fake_run(command, **kwargs):
            if command == ['lake', 'env', 'lean', '--version']:
                output = 'Lean (version 4.34.1, fixture)'
            else:
                self.assertIn('build', command)
                output = json.dumps({'severity': 'error', 'data': 'synthetic exact-build failure'})
            return SimpleNamespace(returncode=0, stdout=output)

        def fake_head(command, **kwargs):
            name = Path(command[4]).name
            return config['public_dependencies'][name]['rev'] + '\n'

        with tempfile.TemporaryDirectory() as temp:
            evidence = Path(temp) / 'failed-run'
            with patch.object(sys, 'argv', [str(SCRIPT), '--evidence-dir', str(evidence)]), \
                 patch.object(verify.subprocess, 'run', side_effect=fake_run), \
                 patch.object(verify.subprocess, 'check_output', side_effect=fake_head):
                with self.assertRaises(AssertionError):
                    verify.main()
            record = json.loads((evidence / 'qualification.json').read_text())
            self.assertEqual(record['status'], 'failed')
            self.assertEqual(record['stages'][-1]['name'], 'exact-build')
            self.assertEqual(record['stages'][-1]['exit_code'], 0)
            self.assertIn('synthetic exact-build failure', record['failure'])


if __name__ == '__main__':
    unittest.main()
