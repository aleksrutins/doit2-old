using Gtk;

namespace Doit2 {
    [GtkTemplate(ui = "/com/munchkinhalfling/DoIt2/tododisplay.ui")]
    public class ToDoDisplay : Box {
        [GtkChild]
        private Label description;
        [GtkChild] private Box days_box;
        public ToDoDisplay(ToDo item) {
            foreach(var day in item.days) {
                days_box.add(new DayLabel(day));
            }
            description.set_text(item.description);
        }
    }
}
