namespace Doit2 {
    public class DayLabel : Gtk.Label {
        public DayLabel(Day day) {
            Object(label: day.name);
            var sc = this.get_style_context();
            sc.add_class("day-label");
            if(day.number == (new Day.today()).number) {
                sc.add_class("doitnow");
            }
        }
    }
}
