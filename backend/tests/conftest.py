import pytest

@pytest.fixture(scope='session')
def django_db_setup():
    pass  # This fixture can be used to set up the database for tests if needed.