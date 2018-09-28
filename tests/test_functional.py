import pytest


@pytest.mark.parametrize(
    "method,path",
    [
        ('get_html', '/'),
        ('get_html', '/legal'),
        ('get_html', '/download'),
        ('get_html', '/societysets'),
        ('get_html', '/societysets/EA'),
        ('get_html', '/contributions/EA'),
        ('get_html', '/contributions/Binford.snippet.html'),
        ('get_html', '/society/B74'),
        ('get_html', '/phylogenys/bouckaert_et_al2018'),
        ('get_html', '/phylogenys/bouckaert_et_al2018?parameter=SCCS1'),
        ('get_json', '/parameters/SCCS1.geojson'),
        ('get_html', '/valuesets/SCCS1716-SCCS100.snippet.html'),
        ('get_html', '/values/SCCS1716-SCCS100-1.snippet.html'),
        ('get_html', '/combinations/SCCS1716_SCCS1717'),
    ])
def test_pages(app, method, path):
    getattr(app, method)(path)
