/* main.vala
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

int main (string[] args) {
    tests();
	var app = new Gtk.Application ("com.munchkinhalfling.DoIt2", ApplicationFlags.FLAGS_NONE);
	app.activate.connect (() => {
	    MainLoop ml = new MainLoop();
		app_activate.begin(app, () => ml.quit());
		ml.run();
	});
	int res = app.run (args);
    save_todos_sync();
	return res;
}
async void app_activate(Gtk.Application app) {
    yield Doit2.Util.load_todos();
    var cssProv = new Gtk.CssProvider();
	cssProv.load_from_resource("/com/munchkinhalfling/DoIt2/app.css");
	Gtk.StyleContext.add_provider_for_screen(Gdk.Screen.get_default(), cssProv, Gtk.STYLE_PROVIDER_PRIORITY_USER);
	var win = app.active_window;
	if (win == null) {
		win = yield new Doit2.Window (app);
	}
	win.present ();
}
/**
 * Save todos synchronously
 */
void save_todos_sync() {
    MainLoop loop = new MainLoop();
    Doit2.Util.load_todos.begin(() => loop.quit());
    loop.run();
}
