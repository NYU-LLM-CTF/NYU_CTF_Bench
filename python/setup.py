import setuptools

with open("README.md", "r", encoding="utf-8") as fh:
    long_description = fh.read()

setuptools.setup(
    name="nyuctf",
    version="1.0",
    author="NYU LLM CTF",
    url='github.com/NYU-LLM-CTF',
    author_email="nyuctf@gmail.com",
    description="API Package for NYU CTF Bench",
    long_description=long_description,
    long_description_content_type="text/markdown",
    package_dir={"": "src"},
    packages=setuptools.find_packages(where="src"),
    python_requires=">=3.6",
)