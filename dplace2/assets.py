from clld.web.assets import environment
from clldutils.path import Path

import dplace2


environment.append_path(
    Path(dplace2.__file__).parent.joinpath('static').as_posix(),
    url='/dplace2:static/')
environment.load_path = list(reversed(environment.load_path))
