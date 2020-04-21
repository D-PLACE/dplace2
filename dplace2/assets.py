import pathlib

from clld.web.assets import environment

import dplace2


environment.append_path(
    str(pathlib.Path(dplace2.__file__).parent.joinpath('static')),
    url='/dplace2:static/')
environment.load_path = list(reversed(environment.load_path))
