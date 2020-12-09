using Gee;
namespace Doit2 {
    public class ToDo : Object {
        public string name;
        public string description;
        public bool done;
        public ArrayList<Day> days;
        public GLib.DateTime done_on;
        public Json.Array days_json;
    }
    public class ToDoList : Object {
        public ArrayList todos_al;
        public Json.Array todos;
        public ToDoList.from_array_list(ArrayList<ToDo> al) {
            todos_al = al;
            foreach(var todo in al) {
                todo.days_json = new Json.Array();
                foreach(var day in todo.days) {
                    todo.days_json.add_object_element(Json.gobject_serialize(day).dup_object());
                }
                todos.add_object_element(Json.gobject_serialize(todo).dup_object());
            }
        }
    }
    public class Day : Object {
        private static ArrayList<string> DAYS_MAP = new ArrayList<string>.wrap({
            "Error",
            "Monday",
            "Tuesday",
            "Wednesday",
            "Thursday",
            "Friday",
            "Saturday",
            "Sunday"
        });
        public int number;
        public string name {
            owned get {
                return DAYS_MAP.@get(number);
            }
            set {
                number = DAYS_MAP.index_of(value);
            }
        }
        public Day(int index) {
            this.number = index;
        }
        public Day.from_name(string dayName) {
            this.name = dayName;
        }
        public Day.today() {
            this.number = (new DateTime.now()).get_day_of_week();
        }
    }
    public class ToDoListItem : Gtk.ListBoxRow {
        public ToDoListItem(ToDo item) {
            activatable = true;
            get_style_context().add_class("sidebar-row");
            get_style_context().add_class("activatable");
            add(new Gtk.Label(item.name));
            show_all();
        }
    }
    public class Util {
        public static void refresh_list(Gtk.Stack list, ArrayList<ToDo?> todos = Util.todos) {
            foreach(var todo in todos) {
                list.add_titled(new ToDoDisplay(todo), todo.name, todo.name);
            }
            list.show_all();
        }
        public static ArrayList<ToDo?> todos;
        static construct {
            todos = new ArrayList<ToDo?>();
        }
        public static string config_path;
        public static async void save_todos() {
            try {
                if(todos == null) {
                    todos = new ArrayList<ToDo?>();
                }
                config_path = Path.build_filename(Environment.get_home_dir(), ".doit2.json");
                log("DoIt2", LogLevelFlags.LEVEL_MESSAGE, "Saving todos to " + config_path);
                string todos_json = Json.gobject_to_data(new ToDoList.from_array_list(todos), null);
                var file = File.new_for_path(config_path);
                if(file.query_exists()) file.delete();
                var outstream = yield file.create_async(FileCreateFlags.REPLACE_DESTINATION);
                yield outstream.write_async(todos_json.data);
            } catch(Error e) {
                log("DoIt2", LogLevelFlags.LEVEL_CRITICAL, "Cannot save todos");
                stdout.puts(e.message + "\n");
            }
        }
        public static async void load_todos() {
            config_path = Path.build_filename(Environment.get_home_dir(), ".doit2.json");
            log("DoIt2", LogLevelFlags.LEVEL_MESSAGE, "Loading todos");
            try {
                uint8[] contents;
                var file = File.new_for_path(config_path);
                yield file.load_contents_async(null, out contents, null);
                var tdl = (ToDoList)Json.gobject_from_data(typeof(ToDoList), (string) contents);
                todos = tdl.todos_al;
            } catch(Error e) {
                log("DoIt2", LogLevelFlags.LEVEL_CRITICAL, "Todo file does not exist or cannot be opened");
                stdout.puts(e.message + "\n");
                todos = new ArrayList<ToDo?>();
            }
        }
    }
}
