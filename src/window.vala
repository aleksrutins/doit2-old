/* window.vala
 *
 * Copyright 2020 munchkinhalfling
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program.  If not, see <http://www.gnu.org/licenses/>.
 */

namespace Doit2 {
	[GtkTemplate (ui = "/com/munchkinhalfling/DoIt2/window.ui")]
	public class Window : Gtk.ApplicationWindow {
        [GtkChild] Gtk.Stack items;
        [GtkChild] Gtk.Button add_btn;
		public async Window (Gtk.Application app) {
			Object (application: app);

			Util.refresh_list(items, Util.todos);
			add_btn.clicked.connect(() => {
                var dlg = new AddToDoDialog();
                dlg.run();
                var days = dlg.get_days();
                Util.todos.add(new ToDo() {
                    name = dlg.name.text,
                    description = dlg.description.buffer.text,
                    days = days
                });
                Util.refresh_list(items, Util.todos);
                Util.save_todos.begin();
			});
		}
	}
}
