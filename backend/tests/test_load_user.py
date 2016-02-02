from unittest import TestCase


class TestLoadUser(TestCase):
    def test_find_user(self):
        from backend import load_user

        user = load_user('Neill', 'password')
        self.assertIsNotNone(user)
        self.assertEqual(user.password, "Password")

        user = load_user("Tony")
        self.assertIsNone(user)
