using Gee;
using Gtk;

namespace Doit2 {
    [GtkTemplate(ui = "/com/munchkinhalfling/DoIt2/addtododialog.ui")]
    public class AddToDoDialog : Gtk.Dialog {
        [GtkChild] private Box days_row_1;
        [GtkChild] private Box days_row_2;
        [GtkChild] public new Entry name;
        [GtkChild] public TextView description;
        public AddToDoDialog() {
            add_button("OK", 1);
            add_button("Cancel", 0);
        }
        public ArrayList<Day> get_days() {
            GLib.List<CheckButton> dayBtns = new GLib.List<CheckButton>();
            ArrayList<Day> res = new ArrayList<Day>();
            foreach(var checkbtn in days_row_1.get_children()) {
                dayBtns.append(checkbtn as CheckButton);
            }
            foreach(var checkbtn in days_row_2.get_children()) {
                dayBtns.append(checkbtn as CheckButton);
            }
            foreach(var gw_btn in dayBtns) {
                if(gw_btn.get_active()) res.add(new Day.from_name(gw_btn.get_label()));
            }
            return res;
        }
    }
}
