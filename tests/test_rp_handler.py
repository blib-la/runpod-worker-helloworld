import unittest
from unittest.mock import patch, MagicMock, mock_open, Mock
import sys
import os

# Make sure that "src" is known and can be used to import rp_handler.py
sys.path.append(os.path.abspath(os.path.join(os.path.dirname(__file__), "..", "src")))
from src import rp_handler


class TestRunpodHelloWorld(unittest.TestCase):
    def test_hello_world_with_string(self):
        # Test with a normal string
        result = rp_handler.hello_world("World")
        self.assertEqual(result, "Hello World")

    def test_hello_world_with_non_string(self):
        # Test with a non-string type (e.g., an integer)
        result = rp_handler.hello_world(123)
        self.assertEqual(result, {"error": "Please provide a String"})

    def test_hello_world_with_empty_string(self):
        # Test with an empty string
        result = rp_handler.hello_world("")
        self.assertEqual(result, "Hello ")
