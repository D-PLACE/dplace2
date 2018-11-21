import pytest


@pytest.mark.parametrize(
    "method,path",
    [
        ('get_html', '/'),
        ('get_html', '/legal'),
        ('get_html', '/download'),
        ('get_html', '/source'),
        ('get_html', '/parameters'),
        ('get_html', '/societysets'),
        ('get_html', '/societysets/EA'),
        ('get_html', '/contributions'),
        ('get_html', '/contributions/EA'),
        ('get_html', '/contributions/Binford.snippet.html'),
        ('get_html', '/society/B74'),
        ('get_html', '/society/B10'),
        ('get_html', '/phylogenys/bouckaert_et_al2018'),
        ('get_html', '/phylogenys/bouckaert_et_al2018?parameter=SCCS1'),
        ('get_html', '/sources/abbott1892'),
        ('get_html', '/parameters/SCCS1'),
        ('get', '/parameters/SCCS1.csv'),
        ('get_json', '/parameters/SCCS1.geojson'),
        ('get_json', '/parameters/B015.geojson'),
        ('get_json', '/parameters/NetPrimaryProductionConstancy.geojson'),
        ('get_html', '/valuesets/SCCS1716-SCCS100.snippet.html'),
        ('get_html', '/values/SCCS1716-SCCS100-1.snippet.html'),
        ('get_html', '/combinations/SCCS1716_SCCS1717'),
        ('get_html', '/combinations/B015_B005'),
        ('get_html', '/phylogenys'),
        ('get_dt', '/parameters?iSortingCols=2&iSortCol_0=5&sSortDir_5=desc&iSortCol_1=0&sSortDir_0=desc'),
        ('get_dt', '/parameters?contribution=Binford'),
        ('get_dt', '/parameters?sSearch_4=economy'),
        ('get_dt', '/contributions'),
        ('get_dt', '/languages'),
        ('get_dt', '/languages?societyset=SCCS'),
        ('get_dt', '/sources'),
        ('get_dt', '/societysets'),
        ('get_dt', '/values'),
        ('get_dt', '/values?language=B10'),
        ('get_dt', '/values?parameter=B015'),
        ('get_dt', '/values?contribution=WNAI'),
    ])
def test_pages(app, method, path):
    getattr(app, method)(path)


def test_redirects(app):
    app.get('/home', status=301)
    app.get('/team', status=301)
    app.get('/publication', status=301)
    app.get('/variable_on_tree?phylogeny=bouckaert_et_al2018&parameter=SCCS1', status=302)
