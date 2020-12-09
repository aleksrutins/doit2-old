using Gee;
namespace Assert {
    public class TestSuiteInstance : Object {
        ArrayList<NamedTestCase?> cases = new ArrayList<NamedTestCase?>();
        string name;
        public void it(string name, TestCase tcase) {
            cases.add(NamedTestCase() {
                name = name,
                tcase = tcase
            });
        }
        public void run() {
            var successes = new ArrayList<NamedTestCase?>.wrap({});
            var failures = new ArrayList<NamedTestCase?>.wrap({});
            foreach(var tcase in cases) {
                try {
                    tcase.tcase();
                    successes.add(tcase);
                } catch(Error e) {
                    failures.add(tcase);
                }
            }
            stdout.puts(@"\\e[1mTest case $name\\e[0m\n");
            stdout.puts("\\e[32mSuccesses:\\e[0m\n");
            foreach (var success in successes) {
                stdout.puts("\t\\e[1;32m" + success.name + "\\e[0m\n");
            }
            stdout.puts("\\e[31mFailures:\\e[0m\n");
            foreach (var failure in failures) {
                stdout.puts("\t\\e[1;31m" + failure.name + "\\e[0m\n");
            }
        }
        public void assert(bool condition, string message) throws Error {
            if(!condition) {
                throw new Error(Quark.from_string("AssertionError"), 1, message);
            }
        }
    }
    public delegate void TestSuite(TestSuiteInstance instance);
    public delegate void TestCase() throws Error;
    public struct NamedTestCase {
        public string name;
        public TestCase tcase;
    }
    public TestSuiteInstance suite(string name, TestSuite tsuite) {
        var instance = new TestSuiteInstance();
        tsuite(instance);
        return instance;
    }
    public class AssertionResult {
        public bool is_error;
        public string message;
        public AssertionResult.error(string message) {
            is_error = true;
            this.message = message;
        }
        public AssertionResult.success() {
            this.is_error = false;
        }
    }
}
