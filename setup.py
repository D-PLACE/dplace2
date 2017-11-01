# setup.py
from setuptools import setup, find_packages


setup(
    name='dplace2',
    version='0.0',
    author='',
    author_email='',
    description='dplace2',
    keywords='',
    url='',
    packages=find_packages(),
    include_package_data=True,
    zip_safe=False,
    install_requires=[
        'clld>=3.3.3',
    ],
    platforms='any',
    long_description='',
    classifiers=[
        'Private :: Do Not Upload',
        'Programming Language :: Python :: 2',
        'Programming Language :: Python :: 2.7',
        'Programming Language :: Python :: 3',
        'Programming Language :: Python :: 3.4',
    ],
    entry_points="""\
    [paste.app_factory]
    main = dplace2:main
    """
)
