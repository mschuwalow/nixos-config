c.ConsoleWidget.font_family = 'Fantasque Sans Mono' 
c.ConsoleWidget.font_size = 10

color_theme = 'monokai'  # specify color theme

import pkg_resources
c.JupyterQtConsoleApp.stylesheet = pkg_resources.resource_filename(
    "jupyter_qtconsole_colorschemes", "{}.css".format(color_theme))

c.JupyterWidget.syntax_style = color_theme
