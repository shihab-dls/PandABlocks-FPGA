import os
from collections import namedtuple

import numpy as np

from .ini_util import read_ini
from .configs import FieldConfig
from .compat import TYPE_CHECKING, add_metaclass

if TYPE_CHECKING:
    from typing import List, Dict, Tuple, Any

# These are the powers of two in an array
POW_TWO = 2 ** np.arange(32, dtype=np.uint32)


def properties_from_ini(src_path, ini_name):
    # type: (str, str) -> Tuple[Any, List[property]]
    assert ini_name.endswith(".block.ini"), \
        "Expected <block>.block.ini, got %s" % ini_name
    block_name = ini_name[:-len(".block.ini")]
    ini_path = os.path.join(os.path.dirname(src_path), ini_name)
    ini = read_ini(ini_path)
    properties = []
    names = []
    for field in FieldConfig.from_ini(ini, number=1):
        if field.type == "time":
            names.append(field.name+"_L")
            prop = property(field.getter, field.settertimeL)
        else:
            names.append(field.name)
            prop = property(field.getter, field.setter)
        properties.append(prop)
    # Create an object BlockNames with attributes FIELD1="FIELD1", F2="F2", ...
    names = namedtuple("%sNames" % block_name.title(), names)(*names)
    return names, properties


class BlockSimulationMeta(type):
    """Metaclass to make sure all field names are bound to the correct
    instance attribute names"""
    def __new__(cls, clsname, bases, dct):
        for name, val in dct.items():
            if isinstance(val, property) and \
                    isinstance(val.fget.im_self, FieldConfig):
                if val.fget.im_self.type == "time":
                    assert name == val.fget.im_self.name + "_L", \
                        "Property %s mismatch with FieldConfig name %s" % (
                            name, val.fget.im_self.name)
                else:
                    assert name == val.fget.im_self.name, \
                        "Property %s mismatch with FieldConfig name %s" % (
                            name, val.fget.im_self.name)
        return super(BlockSimulationMeta, cls).__new__(cls, clsname, bases, dct)


@add_metaclass(BlockSimulationMeta)
class BlockSimulation(object):
    bit_bus = np.zeros(128, dtype=np.bool_)
    pos_bus = np.zeros(32, dtype=np.int32)

    #: This will be dictionary with changes pushed by any properties created
    #: with properties_from_ini()
    changes = None

    @classmethod
    def bits_to_int(cls, bits):
        """Convert 32 element bit array into an int number"""
        return np.dot(bits, POW_TWO)

    def on_changes(self, ts, changes):
        """Handle field changes at a particular timestamp

        Args:
            ts (int): The timestamp the changes occurred at
            changes (Dict[str, int]): Fields that changed with their value

        Returns:
             If the Block needs to be called back at a particular ts then return
             that int, otherwise return None and it will be called when a field
             next changes
        """
        # Set attributes
        for name, value in changes.items():
            assert hasattr(self, name), "%s has no attribute %s" % (self, name)
            setattr(self, name, value)

