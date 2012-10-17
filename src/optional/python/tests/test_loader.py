import pandas as pd
import unittest

from gnuparallel import load

result_dir = '../../testresults'

class TestLoader(unittest.TestCase):

    def test_basics(self):
        df = load(result_dir)
        self.assertEqual(set(df.columns), set(['a', 'b', '_prefix', 'resfile', '_stream']))
        self.assertEqual(df.shape[0], 8)

    def test_prefix(self):
        df = load(result_dir, _prefix='foo_')
        self.assertEqual(df.shape[0], 4)
        self.assertEqual(df.a.sum(), 6)

        df = load(result_dir, _prefix='bar_')
        self.assertEqual(df.shape[0], 4)
        self.assertEqual(df.a.sum(), 22)

        df = load(result_dir, _prefix='BAD')
        self.assertTrue(df.empty)

    def test_filters(self):
        df = load(result_dir, a=2)
        self.assertEqual(df.shape[0], 2)
        self.assertEqual(df.a.sum(), 4)

        df = load(result_dir, a=[2])
        self.assertEqual(df.shape[0], 2)
        self.assertEqual(df.a.sum(), 4)

        df = load(result_dir, a=[1,2])
        self.assertEqual(df.shape[0], 4)
        self.assertEqual(df.a.sum(), 6)

        df = load(result_dir, a=1000)
        self.assertTrue(df.empty)

    def test_infer_types(self):
        df = load(result_dir)
        self.assertEqual(df.a.dtype, pd.np.int64)

        df = load(result_dir, _infer_types=False)
        self.assertEqual(df.a.dtype, pd.np.object_)

    def test_format(self):
        df = load(result_dir, b=0.3)
        self.assertTrue(df.empty)

        df = load(result_dir, b=0.3, _format={'b': '%.2f'})
        self.assertEqual(df.shape[0], 2)

    def test_stream(self):
        df = load(result_dir, _stream='stderr')
        self.assertTrue((df._stream == 'stderr').all())

    def test_process(self):
        df = load(result_dir, a=1, _process=lambda x: pd.np.loadtxt(x).sum())
        self.assertAlmostEqual(df.res[0], 1.4)

if __name__ == '__main__':
    unittest.main()
