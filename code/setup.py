from setuptools import setup, find_packages

setup(name='sccm',
      version='0.2',
      description='Agent Based Simulation of the Cryptocurrency Market',
      url='https://github.com/inailuig/simulating_cryptocurrency_markets',
      author='<todo>',
      author_email='<todo>',
      license='<todo>',
      packages=['sccm'],
      install_requires=[
          'numpy',
          'mesa'
      ],
      scripts=['scripts/sccm','scripts/sccm-plot','scripts/sccm-mcavg'],
      include_package_data=True,
      zip_safe=False)
