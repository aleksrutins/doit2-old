add_project_arguments(['--vapidir=/usr/share/vala-0.50/vapi'], language: 'vala')
subdir('libassert')
doit2_sources = [
  'main.vala',
  'window.vala',
  'util.vala',
  'tododisplay.vala',
  'daylabel.vala',
  'addtododialog.vala',
  'tests.vala'
]
doit2_sources += libassert

doit2_deps = [
  dependency('gio-2.0', version: '>= 2.50'),
  dependency('gtk+-3.0', version: '>= 3.22'),
  dependency('gee-0.8'),
  dependency('json-glib-1.0')
]

gnome = import('gnome')

doit2_sources += gnome.compile_resources('doit2-resources',
  'doit2.gresource.xml',
  c_name: 'doit2'
)
executable('doit2', doit2_sources,
  vala_args: '--target-glib=2.50',  dependencies: doit2_deps,
  install: true
)

