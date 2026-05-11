---
title: Python Pydantic V2 - The Objects and Relationships
date:
  created: 2026-02-26
categories: [python]
tags:
  - python
  - pydantic
authors:
  - hafiz
readtime: 20
slug: python_pydantic_v2
draft: false
---

Pydantic is a data validation library for Python. 🚀⚡

<!-- more -->

## What is Pydantic?

!!! info "Pydantic"
    A framework for defining specilized python class. class is called `model` and attributes are called `fields`. Simple way to load data from `dictionary` or `json` to a model and validate it. This process is called `deserialization`. We can also extract the model to a `dictionary` or `json` from a model. This process is called `serialization`.

## Model Basics

```python
from pydantic import BaseModel, ValidationError # (1)!

class User(BaseModel): # (2)!
    first_name: str # (3)!
    last_name: str
    age: int
    
    @property # (4)!
    def full_name(self): # (5)!
        return f"{self.first_name} {self.last_name}"
    
user1 = User(first_name="John", last_name="Doe", age=30) # (6)!
print(str(user1)) # (7)!
print(repr(user1)) # (8)!
print(user1.first_name) # (9)!
user1.age = 31 # (10)!
print(user1.full_name) # (11)!
try:
    error_user = User(first_name="John", age=40) # (12)!
    user1.age = "Thirty Two" # (13)!
except ValidationError as e:
    print(e) # (14)!
```

1. ➕ Inclusion of `BaseModel` and `ValidationError` from `pydantic`.
2. ⤵️ Inheritance of `BaseModel`.
3. 👍Model attribures with type annotations.
4. ✨ `@property` to define computed fields.
5. `self` defined as the instance of he valid model.
6. 🍏 One of the object creation process.
7. Pydantic out of the box offers the `str` method.
8. Pydantic out of the box offers the `repr` method.
9. You can also assign value to the attributes.
11. Calling the property method.
12. Creating an invalid Model instance.
13. Assigning a non-integer value to the age attribute.
14. Exception is raised with the validation error. Will print the error message pointing out what is the issue, for which attributes the error occures, what is expected and what is received.

!!! warning "Validation Error"
    Pydantic will not by default support the validation attributes assignment. In the above example `user1.age = "Thirty Two"` will noot raise a validation error.

### Serialization and Deserialization

```python linenums="1"
# Deserialization
p1 = User(first_name="Alex", last_name="Hue", age=30)
data = {
    "first_name": "Bob",
    "last_name": "Smith",
    "age": 60
}
p2 = User.model_validate(data)
json_data = '''
{
    "first_name": "Alice",
    "last_name": "Johnson",
    "age": 25
}
'''
p3 = User.model_validate_json(json_data)

# Serialization
print(p1.model_dump())
print(p1.model_dump_json())
print(p2.model_dump_json(indent=4, exclude=['age']))
print(p3.model_dump(include=['first_name', 'last_name']))
```
### Model Coercion

Sometimes when deserializing, the data types might not match the type annotations. In such cases, Pydantic will try to coerce the data types to match the type annotations. This is called model coercion. There are two modes `strict` and `lax`. By default, Pydantic is in `lax` mode. In `strict` mode, Pydantic will not coerce the data types to match the type annotations.

```python linenums="1" hl_lines="6"
class Cordinates(BaseModel):
    x: float
    y: float
    z: float

point = Cordinates(x=1.2, y=5, z="6.7")
print(point)
```
```shell title="output"
x=1.2 y=5.0 z=6.7
```
### Required Vs Optional

```python linenums="1" hl_lines="2"
class Circle(BaseModel):
    center: tuple[float, float] = (0,0) # (1)!
    radius: float
```

1. ➕ Default value is provided for the center attribute.

!!! warning
    By default pydantic also do not validate the default value in model defination.

!!! danger
    When you are defining anything default, remember that default will be initialized only once and during the `compile` time. Each time it's called-will have the default value, something added to the default value will be there for all the instances. So, if you are using a mutable object as default value, it's a bad idea. But in pydantic is perfectly `**safe**` to do.

!!! info
    **Mutable** objects that can be changed after being created. `list`, `dict`, `set`, `bytearray` are mutable objects. **Immutable** objects that cannot be changed after being created. `int`, `float`, `complex`, `str`, `tuple`, `frozenset`, `bytes` are immutable objects. If you change an immutable object, python will create a new object in the memory.

### Nullable Fields

```python linenums="1" hl_lines="3"
class Model(BaseModel):
    field1: int = 0 # (1)!
    field2: int | None # (2)!
    field3: int | None = None # (3)!
    field4: Optional[int] # (4)!
    field5: int = None # (5)!
    field: int = 0
```

1. 🗨️ Default value is provided for the field1 attribute.
2. 🗨️ Field2 is nullable.
3. 🗨️ Field3 is nullable and has a default value.
4. 🗨️ Field4 is nullable and has a default value. But this field is required in point of view of pydantic. I will not recommand this approach.
5. Not totally recommanded. We are saying the type `int` but assigning `None` to it. It's only working because not validation is done on default value.
6. Optional but not nullable.

## Model Configuration
Model configuration is a way to modify pydantic default behavior and add additional configurations in case we need. We have to configure a `ConfigDict` object and add it to the model.

### Extra Fields

By default pydantic ignores the extra fields provided in deserialization.
```python
class Model(BaseModel):
    field1: int
    
obj = Model(field1="1", field2="2") # (1)!
```

1. By default pydantic ignores the extra fields provided in deserialization.

We can modify the behavior with the `ConfigDict` object, with `extra` attribute and three possible values `ignore`, `allow` and `forbid`. `ignore` is the default value.

```python linenums="1" hl_lines="2"
class Model(BaseModel):
    model_config = ConfigDict(extra="forbid") # (1)!
    field1: int
    
obj = Model(field1="1", field2="2") # (2)!
```

1. We are setting the `extra` attribute to `forbid`.
2. This will raise a validation error.

```python linenums="1" hl_lines="2"
class Model(BaseModel):
    model_config = ConfigDict(extra="allow") # (1)!
    field1: int
    
obj = Model(field1="1", field2="2") # (2)!
```

1. We are setting the `extra` attribute to `allow`.
2. This will not raise a validation error. You will see the extras if needed.

### Strict and Lax Coercion

By default pydantic is in `lax` mode. In `strict` mode, pydantic will not coerce the data types to match the type annotations.

```python linenums="1" hl_lines="2"
class Model(BaseModel):
    model_config = ConfigDict(strict=True) # (1)!
    field: float
```

1. We are setting the `strict` attribute to `True`.

### Validating Default Values
Pydantic will not validate the default values in model defination. To enable it we have to use `validate_default` attribute.

```python linenums="1" hl_lines="2"
class Model(BaseModel):
    model_config = ConfigDict(validate_default=True) # (1)!
    field: int = 1
```

1. We are setting the `validate_default` attribute to `True`.

We can also do this in field level.

### Validating Assignments

By default pydantic will not validate the assignments. To enable it we have to use `validate_assignment` attribute.

```python linenums="1" hl_lines="2"
class Model(BaseModel):
    model_config = ConfigDict(validate_assignment=True) # (1)!
    field: int = 1
```

1. We are setting the `validate_assignment` attribute to `True`.

### Mutability

By default pydantic models are mutable. To make it non-mutable we have to use `frozen` attribute.

```python linenums="1" hl_lines="2"
class Model(BaseModel):
    model_config = ConfigDict(frozen=True) # (1)!
    field: int = 1
```

1. We are setting the `frozen` attribute to `True`.

!!! info
    When we are making the model non-mutable, it will become hashable and we will be able to use it as a key in a dictionary.

### Coercing Number to String
```python linenums="1" hl_lines="2"
class Model(BaseModel):
    model_config = ConfigDict(coerce_numbers_to_str=True) # (1)!
    field: str

obj = Model(field=1) # (2)!
print(obj)
```

1. We are setting the `coerce_numbers_to_str` attribute to `True`.
2. We are coercing the number to string. This will work.

### String Standardization

```python linenums="1" hl_lines="2"
class Model(BaseModel):
    model_config = ConfigDict(str_strip_whitespace=True, str_to_lower=True) # (1)!
    field: str

obj = Model(field="  Hello  ") # (2)!
print(obj)
```

1. We are setting the `str_strip_whitespace` attribute to `True`. `str_to_lower` is also available.
2. We are stripping the whitespace from the string. Also make the value lower.

### Handling Enums

```python linenums="1" hl_lines="7"
class Color(str, Enum):
    RED = "red"
    GREEN = "green"
    BLUE = "blue"

class Model(BaseModel):
    model_config = ConfigDict(use_enum_values=True) # (1)!
    color: Color
    
object = Model(color=Color.RED)
```

1. We are setting the `use_enum_values` attribute to `True`. This will allow us to use the enum values as the field values.

There are other configurations:

- `config`

## Field Aliases
For naming convension, reserved keywords we need to use `aliases`. When we de-serialize, the name we feed is the `aliase` and that maps to a attribues in the model. One name in desearilizing is `aliese` other name in Pydantic model is `field name` another name when searilizing called `searilization aliese`. By deafult you can only deserialize with `aliase` when defined, but we have option to consider both. 

`ID` | `Aliase` -> `Deserialization` -> `id_` | `Model Field` -> `Serialization` -> `id` | `Searilizing Alias`

Aanother aliases is called `Validation Aliase`. It overide plain aliases if it is present. We will see the usage in the code example.

- `alias` | serialization: `alias` & deserialization: `aliase`.
- `validation_aliase` + `alias` | serialization: `aliase` & deserialization: `validation_aliase`.
- `alias` + `sealization_aliase` | serialization: `serealization_aliase` & deserialization: `aliase`.
- `validation_aliase` + `alias` + `serialization_aliase` | serialization: `serialization_aliase` & deserialization: `validation_aliase`.

At model level we can define `automatic` aliase. with a function and attach with model configuration. We can also do custom serialization.

### Using basic `aliase`
You need to use the `Field` object and `aliase` attribute of the object to declare the aliase.

```python linenums="1" hl_lines="2-5 14-17 19"
class Model1(BaseModel):
    field1_: int = Field(alias="id") # (1)!
    field2: str = Field(alias="field2Alias") # (2)!
    field_default: int = Field(alias="fieldDefault", default=18) # (3)!
    field_nullable: str | None = Field(alias="fieldNullable", default=None) # (4)!
json_data = '''
{
    "id": 1,
    "field2Alias": "John",
    "fieldDefault": 18,
    "fieldNullable": "John"
}
'''
obj = Model1.model_validate_json(json_data) # (6)!
print(obj.field2) # (7)!
print(obj.model_dump()) # (8)!
print(obj.model_dump(by_alias=True)) # (9)!
try:
    Model1(field1_="100", field2Alias="John") # (10)!
except ValidationError as e:
    print(e)
```

1. The `alias` is decleared here. It will be used for deserialization. Model attributes have to fetch from the **attribute name**.
2. Same as `field1_`.
3. `Field` is used here to add default value to the attribute.
4. This field is `null-able` and also have default value.
5. JSON string for deserialization. notice the `key` names here. They are aligned with the `alias` names.
6. Deserializing the JSON string.
7. Accessing the field value. With the model `attribute` name, not with the `alias` name.
8. Serializing the model to a dictionary with default behavior. It will consider field name as `key` name.
9. Seraializing with `by_alias=True`. It will consider `alias` name as `key` name.
10. Once aiases are defined,deserializing with `field` name instade of `aliases` will through exception.

```shell title="output"
John
{'field1_': 1, 'field2': 'John', 'field_default': 18, 'field_nullable': 'John'}
{'id': 1, 'field2Alias': 'John', 'fieldDefault': 18, 'fieldNullable': 'John'} 
1 validation error for Model1
id
  Field required [type=missing, input_value={'field1_': '100', 'field2Alias': 'John'}, input_type=dict]
```

!!! info
    Sometime you will see the use of `<veriable_name_>`. It's just because it's the conventional way for using reserved keywords as variable names.

!!! warning
    `populate_by_name=True` is used to deserialize the model but either `aiase` name or model `field` name. It's not used for serialization.

### Aliase Generator

Pydantic offers some predefined `aliase_generator` methods. `to_camel`, `to_snake`, `to_pascal` are some of them. We also have the ability to define and use custom aliase generator.

#### Predefined Aliases Generator

```python linenums="1" hl_lines="1 3 7"
from pydantic.alias_generators import to_camel # (1)!
class Model(BaseModel):
    model_config = ConfigDict(aliase_generator=to_camel) # (2)!
    field_one: int
    field_two: str

obj = Model(fieldOne=1, fieldTwo="Two") # (3)!
```

1. Import pre-defined aliase generator `to_camel` from `pydantic`.
2. Use `aliase_generator` model config to specifiy the generator method.
3. Make sure to use the `camelCasing` key names when deserializing with key names, dictionary of JSON string.

#### Custom Aliases Generator

```python linenums="1" hl_lines="1-2 5-6 9"
def make_upper(input_str: str) -> str: # (1)!
    return input_str.upper()

class Model(BaseModel):
    model_config = ConfigDict(alias_generator=make_upper) # (2)!
    field_id_: int = Field(alias="ID") # (3)!
    field_one: str
    
obj = Model(ID=1, FIELD_ONE="John") # (4)!
```

1. Custom aliase generator function.
2. Use `aliase_generator` model config to specifiy the generator method.
3. With generator we will have `FIELD_ID_` as the `aliase`. But sience we are defining in the `Field` level, `ID` will get the precedence over the generator.
4. Deserializing based on the generated aliases.

### Validation, Serialization Aliases and Multiple Aliases

We can also define own ans specific validation aliases and serialization aliases. We need to use the `validation_alias` and `serialization_alias` attributes of the `Field` object. We will also see how to use multiple aliases.

!!! info
    `populate_by_name=True` is used to deserialize the model but either `aiase` name or model `field` name.

```python linenums="1" hl_lines="4 6-10 12"
from pydantic import AliasChoices
class Model(BaseModel):
    model_config = ConfigDict(
        populate_by_name=True, # (1)!
    )
    field_id_: int = Field(alias="id") # (2)!
    field_one: str = Field(serialization_alias="field_1") # (3)!
    field_two: str = Field(validation_alias="field_2", default="Zao") # (4)!
    field_three: str = Field(validation_alias="fieldThree", alias="field_Three", serialization_alias="field_3") # (5)!
    field_four: str = Field(validation_alias=AliasChoices("field_4", "field4", "field_Four"), serialization_alias="field_4") # (6)!
    
obj = Model(id=1, field_one="John", fieldThree="Doe", field4="Smith") # (7)!
print(obj.model_dump())
print(obj.model_dump_json(by_alias=True))
```

1. `populate_by_name=True` is used to deserialize the model but either `aiase` name or model `field` name.
2. `alias` is used for both serialization (`by_alias=True`) and deserialization (by default).
3. `serialization_alias` is used for serialization only (`by_alias=True`) and field name will be used for deserialization.
4. `validation_alias` is used for deserialization only (by default). 
5. `validation_alias` will be used for deserialization and `serialization_alias` will be used for serialization (`by_alias=True`). By default serialization will take the field name.
6. `AliasChoices` is used to specify multiple deserialization aliases for a field.
7. `id` because we defined `alias="id"` for `field_id_`. `field_one` because model field name, `fieldThree` because `validation_alias` for `field_three`, `field4` because `AliasChoices` for `field_four`. 

```shell linenums="1" title="output"
{'field_id_': 1, 'field_one': 'John', 'field_two': 'Zao', 'field_three': 'Doe', 'field_four': 'Smith'}
{"id":1,"field_1":"John","field_two":"Zao","field_3":"Doe","field_4":"Smith"}
```

!!! warning
    For `AliasChoices` - during deserialization, if multiple keys of same field are found, the last found will be considered.

### Custom Serializers
There are cases where we need to define our own serialized format or processing for business and other purposes. Pydantic have a feature for that. We can use `@field_serializer` decorator to define a custom serializer for a field.

```python linenums="1" hl_lines="1 5"
from pydantic import field_serializer # (1)!
from datetime import datetime

class Model5(BaseModel):
    dt: datetime | None = None
    
    @field_serializer("dt", when_used="json-unless-none") # (2)!
    def serialize_dt(self, value): # (3)!
        return value.strftime("%Y-%m-%d %I:%M:%S %p") # (4)!
    
obj5 = Model5(dt=datetime.now())
print(obj5.model_dump_json()) # (5)!
```

1. Import `field_serializer` from `pydantic`.
2. Use `field_serializer` decorator to define a custom serializer for a field. also use `when_used` parameter to define when to call the serializer function.
3. `self` is the instance of the model, and `value` is passed by default - which is the foeld value. We can also pass `info` parameter which is `FieldSerializationInfo` object.
4. The processing of field before for serialization.
5. The serializer function takes the value of the field as the first parameter and returns the serialized value.

```shell title="output" linenums="1"
{"dt":"2026-02-13 22:07:55 10 PM"}
```
???+ info
    `when_used` parameter can be set to `always`, `unless_none`, `json`, `json-unless-none`.

    - `always`: Always serialize the field.
    - `unless_none`: Serialize the field only if it is not `None`.
    - `json`: Serialize the field only if it is used in `model_dump_json()`.
    - `json-unless-none`: Serialize the field only if it is not `None` and used in `model_dump_json()`.

> It defines when to call the serializer function.

## Specialized Pydantic types with Validations

Pydantic offers a larg varity of default validation types out of the box. They can be categorized into two groups:

1. Pydantic Types. <a href="https://docs.pydantic.dev/latest/api/types/" target="_blank">Details</a>
2. Network Types. <a href="https://docs.pydantic.dev/latest/api/networks/" target="_blank">Details</a>

We will try to touch some of them here.

### Pydantic Types

```python linenums="1" hl_lines="6-16"
from pydantic import BaseModel, Field, ValidationError, ConfigDict ,PositiveInt, conlist, UUID4, PastDatetime, FutureDatetime, AwareDatetime, NaiveDatetime, FilePath, DirectoryPath, NewPath, StringConstraints
import datetime
from typing import Annotated

class Model(BaseModel):
    always_positive: PositiveInt # (1)!
    constrained_list: conlist(int, min_length=1, max_length=10) # (2)!
    uuid_field: UUID4 # (3)!
    past_date_field: PastDatetime = Field(default_factory=lambda: datetime.datetime.now() - datetime.timedelta(hours=1)) # (4)!
    future_date_field: FutureDatetime = Field(default_factory=lambda: datetime.datetime.now() + datetime.timedelta(hours=1)) # (5)!
    aware_date_field: AwareDatetime = Field(default_factory=lambda: datetime.datetime.now(tz=datetime.timezone.utc)) # (6)!
    naive_date_field: NaiveDatetime = Field(default_factory=lambda: datetime.datetime.now()) # (7)!
    file_path_field: FilePath # (8)!
    directory_path_field: DirectoryPath # (9)!
    new_path_field: NewPath # (10)!
    string_constrains: Annotated[str, StringConstraints(strip_whitespace=True, to_lower=True, min_length=1, max_length=10, pattern="^[a-zA-Z0-9]*$")] # (11)!
```

1. `PositiveInt` ensures the value is always positive.
2. `conlist` ensures the type, min and max length.
3. `UUID4` ensures valid uuid.
4. `PastDatetime` ensures valid past datetime.
5. `FutureDatetime` ensures valid future datetime.
6. `AwareDatetime` ensures valid aware datetime.
7. `NaiveDatetime` ensures valid naive datetime.
8. `FilePath` ensures the file exists.
9. `DirectoryPath` ensures the directory exists.
10. `NewPath` ensures the path is new. The parent directory must exist.
11. `StringConstraints` ensures the string is valid. we can use it to strip whitespace, convert to lower case, ensure min and max length, and ensure the string matches a regex pattern.

!!! info
    We can add some logical conditions like `ge`, `gt`, `le`, `lt`, `eq`, `ne`, `in`, `multiple_of` for validation. `default_factory` is used to set the default value for the field. The main difference is that the default value will be called each time a model object is created.


Here is an example of a perfect object.

```python title="test.py" linenums="1"
existing_file_path = Path('existing_file.txt') 
existing_directory_path = Path('existing_directory')
existing_file_path.touch() # (1)!
existing_directory_path.mkdir(exist_ok=True) # (2)!
new_path = Path('new_file_path.txt')
if new_path.exists():
    new_path.unlink() # (3)!

obj = Model(
    always_positive=1,
    constrained_list=[1, 2, 3, 4, 5],
    uuid_field="123e4567-e89b-12d3-a456-426614174000",
    past_date_field=datetime.datetime.now() - datetime.timedelta(hours=6),
    future_date_field=datetime.datetime.now() + datetime.timedelta(hours=6),
    aware_date_field=datetime.datetime.now(tz=datetime.timezone.utc),
    naive_date_field=datetime.datetime.now(),
    file_path_field='existing_file.txt',
    directory_path_field='existing_directory',
    new_path_field=new_path,
    string_constrains="Hello"
)

print(obj.model_dump_json(indent=4))
```

1. `existing_file_path.touch()` creates the file.
2. `existing_directory_path.mkdir(exist_ok=True)` creates the directory.
3. `new_path.unlink()` deletes the file.

And the output will be
```shell title="output" linenums="1"
{
    "always_positive": 1,
    "constrained_list": [
        1,
        2,
        3,
        4,
        5
    ],
    "uuid_field": "241308ab-c95f-49ba-a071-dfdd33920078",
    "past_date_field": "2026-02-25T09:20:23.864432",
    "future_date_field": "2026-02-25T21:20:23.864471",
    "aware_date_field": "2026-02-25T09:20:23.864481Z",
    "naive_date_field": "2026-02-25T15:20:23.864483",
    "file_path_field": "existing_file.txt",
    "directory_path_field": "existing_directory",
    "new_path_field": "new_file_path.txt",
    "string_constrains": "hello"
}
```

Now let's see a not so perfect object that pydantic can judge.

```python title="test.py" linenums="1"
try:
    not_perfect_object = Model(
        always_positive=0,
        constrained_list=[1, 2.0, 3, 4, 5, 8, 9, 10, 12, 12, 13],
        uuid_field="123e4567-e89b-12d3-a456-426614174000",
        past_date_field=datetime.datetime.now(),
        future_date_field=datetime.datetime.now(),
        aware_date_field=datetime.datetime.now(),
        naive_date_field=datetime.datetime.now(),
        file_path_field='non_existing_file.txt',
        directory_path_field='non_existing_directory',
        new_path_field=new_path,
        string_constrains="Hello World!"
    )
except ValidationError as e:
    print(e)
)
```
```shell title="output" linenums="1"
8 validation errors for Model
always_positive
  Input should be greater than 0 [type=greater_than, input_value=0, input_type=int]
constrained_list
  List should have at most 10 items after validation, not 11 [type=too_long, input_value=[1, 2.0, 3, 4, 5, 8, 9, 10, 12, 12, 13], input_type=list]
uuid_field
  UUID version 4 expected [type=uuid_version, input_value='123e4567-e89b-12d3-a456-426614174000', input_type=str]
past_date_field
  Input should be in the past [type=datetime_past, input_value=datetime.datetime(2026, 2, 25, 15, 27, 32, 443965), input_type=datetime]       
future_date_field
  Input should be in the future [type=datetime_future, input_value=datetime.datetime(2026, 2, 25, 15, 27, 32, 443965), input_type=datetime]       
aware_date_field
  Input should have timezone info [type=timezone_aware, input_value=datetime.datetime(2026, 2, 25, 15, 27, 32, 443966), input_type=datetime]      
file_path_field
nput_type=str]
string_constrains
  String should have at most 10 characters [type=string_too_long, input_value='Hello World!', input_type=str]
```

### Network Types

```python title="network_type.py" linenums="1" hl_lines="4-8"
from pydantic import UrlConstraints, AnyUrl, EmailStr, NameEmail, HttpUrl, IPvAnyAddress

class NetModel(BaseModel):
    any_url: AnyUrl  # (1)!
    email_str: EmailStr # (2)!
    name_email: NameEmail # (3)!
    http_url: HttpUrl # (4)!
    ipv_any_address: IPvAnyAddress # (5)!
```

1. `AnyUrl` ensures the value is a valid URL. It offers different attributes like `host`, `port`, `path`, `query`, `fragment`, etc.
2. `EmailStr` ensures the value is a valid email address.
3. `NameEmail` ensures the value is a valid email address with name. We can access the `name` and `email` attributes.
4. `HttpUrl` ensures the value is only a valid httpurl. If you try with a `ftp` url it will fail.
5. `IPvAnyAddress` ensures the value is a valid IP address. It can be IPv4 or IPv6.


!!! warning
    For using `EmailStr` you need to install `email-vaidator` package with `pip install email-validator`

Let's create an object now.

```python title="network_type.py" linenums="1"
net_object = NetModel(
    any_url="https://sub-domain.domain.com:443/file/q=check",
    email_str = "group@sub-domain.domain.com",
    name_email = "Support Group <support.group@sub-domain.domain.com>",
    http_url = "https://sub-domain.domain.com",
    ipv_any_address = "192.168.0.1",
)

print(f"Scheme: {net_object.any_url.scheme}\nHost: {net_object.any_url.host}\nPort: {net_object.any_url.port}\nPath: {net_object.any_url.path}\nQuery: {net_object.any_url.query}")
print(f"Email: {net_object.email_str}")
print(f"Name: {net_object.name_email.name}, Email: {net_object.name_email.email}")
print(f"HTTP URL: {net_object.http_url}")
print(f"IPv Any Address: {net_object.ipv_any_address}")
```
And the output will be
```shell title="output" linenums="1"
Scheme: https
Host: sub-domain.domain.com
Port: 443
Path: /file/q=check
Query: None
Email: group@sub-domain.domain.com
Name: Support Group, Email: support.group@sub-domain.domain.com
HTTP URL: https://sub-domain.domain.com/
IPv Any Address: 192.168.0.1
```

## Additional fields configuration

A lot of time we may only need to add configurations to just the field/s. Let's see how we can add additional configurations to just the field/s.
Check the example first.

```python title="additional_fields_configuration.py" linenums="1"
from pydantic import BaseModel, Field, ValidationError, ConfigDict

class Model(BaseModel):
    model_config = ConfigDict(strict=False, validate_default=True) # (1)!
    field1: bool = Field(strict=True, default=False) # (2)!
    field2: int = Field(frozen=True, default=1.0) # (3)!
    field3: bool = Field(strict=True, validate_default=False, default=100.0) # (4)!
    field4: str = Field(description="Hide me from serialization", exclude=True, default="I am secret") # (5)!
model_obj_1 = Model(field1=True, field2=0) # (6)!
print(model_obj_1) # (7)!
try:
    model_object_2 = Model(field1=1.0, field2=False) # (8)!
except ValidationError as e:
    print(e)

try:
    model_obj_1.field2 = True # (9)!
except ValidationError as e:
    print(e)
```

1. In model config level we are making the model files `lux` and making default value validation `True`.
2. Will make this field strict only. So coercion will not work.
3. It will be `lux`, `default` validation will work, but you won't be able to change the value of this field.
4. Will make this field strict only and default value will no longer be validated. Will take `100.0` as the default value though it's a bool.
5. Will exclude this field from serialization.
6. Will successfully create the object. There will be no valifdation error.
7. Will give the output `field1=True field2=0 field3=1.0`
8. Will raise a validation error because `field1` is not a bool.
9. Will raise a validation error because `field2` is frozen and you can't change the value of this field.

!!! warning
    `frozen` do not work as other does. You can't just make the model frozen in `ConfigDict` object and just make a field un-frozen. That will not work. But you can make a field frozen when the Model is not frozen.

## Annotated Type

> A way to add metadata to an existing type. Python does nothing with it, but third-party libraries can use for their own use. Pydatic use it in high scale. We can annotate `Field`, `validators`, `serailizers`.

```python title="annotated_type.py" linenums="1"
from typing import Annotated
from typing import get_args, TypeVar # (1)!
from pydantic import BaseModel, Field, StringConstraints # (2)!

SpecialType = Annotated[str, "Python does not care about it", [1,2,4], True] # (3)!
print(get_args(SpecialType)) # (4)!

BoundedInt = Annotated[int,Field(gt=0, le=100)] # Pydantic understands this and knows what to do with it. # (5)!
BoundedStr = Annotated[str, Field(min_length=3, max_length=10, default="No Shape")] # (6)!
BoundedListStr = Annotated[list[str], Field(min_length=1, max_length=5)] # (7)!
StandardString = Annotated[
    str,
    StringConstraints(
        to_lower=True,
        min_length=3,
        strip_whitespace=True,
    )
] # (8)!

T = TypeVar('T') # (9)!
DynamicBoundedType = Annotated[T, Field(gt=0, le=100)] # (10)!
DynamicBoundedList = Annotated[list[T], Field(min_length=1, max_length=5)] # (11)!

class Model(BaseModel):
    x: BoundedInt # (12)!
    y: DynamicBoundedType[int] # (13)!
    z: DynamicBoundedType[float] # (14)!
    shape_name: BoundedStr # (15)!
    labels: BoundedListStr 
    colors: DynamicBoundedList[str] # (16)!
    code: StandardString # (17)!
    
print(Model.model_json_schema()) # (18)!
```

1. Import `Annotated` from `typing` to annotate the type. `TypeVar` is used to create a type variable. `get_args` is used to get the arguments of the type.
2. Import `StringConstraints` from `pydantic` to add more validation rule to `str`
3. Using `Annotated` we are annotating the type with metadata. Python does not care about it.
4. That should give the output `(<class 'str'>, 'Python does not care about it', [1, 2, 4], True)`
5. This will add field level validation type with `Annotated` type. It can be reusable.
6. Another Annotated type with `Field` object for String type.
7. Another Annotated type with `Field` object for List of String type.
8. Another Annotated type with `StringConstraints`. It helps to add more validation to the `str` type like `to_lower`
9. `TypeVar` represent any type of variable. It's a generic type.
10. Using `TypeVar` here for dynamically bound variable type. Any type of variable will now be annotated. Now we can use it with any type of variable with any number of time.
11. We can also use `TypeVar` with `list` type.
12. Saying `x` is an `int` and value can be between 0-100 inclusive.
13. Print the model json schema.

## Custom Validator

!!! infor Pydantic Validation Steps
    Data => Field Type Hint | Validation => Model instance field

Some times we need more of of a custom validation. For that we can use `Custom Validator`.

> **Custom Validator** is a function - `input` | (Raw value or already validated by Pydantic) Data being deserialized, `output` | Validation data. We can technically return a value that is completly different form the input value. We also can call it a transformation function. We can validate in both before/after (Before/After Validator) pydantic validation. We can have multiple custom validator and mixture of Before and After validator. It will work like pipeline of functions, output of one function will be input of the next function. Order depends on the order of the function in the class.

```python
# Defination Order
before_validator_1()
before_validator_2()
pydantic_validation()
after_validator_1()
after_validator_2()

# Execution Order
before_validator_2()
before_validator_1()
pydantic_validation()
after_validator_2()
after_validator_1()

# Defination Order
before_validator_1()
after_validator_1()
before_validator_2()
after_validator_2()

# Execution Order
before_validator_2()
before_validator_1()
pydantic_validation()
after_validator_2()
after_validator_1()
```

!!! info More features of Custom Validator
    - Can be applied individual field, defined using `decorator`
    - Can reference other fields in model.
    - Same validator can be applied to multiple fields.
    - Can be attached to a type using `Annotated` type.

For custom validtion error, it raise `ValueError`, You can also raise `assertion` error but avoid it, assertion error can be surpressed. They will result in pydantiv `ValidationError` object. Other error will be show up as it is.


!!! Info
    There are also overall model validators, plain validators, wrap validators.

The syntax is, inside class you need to define each validator as `@validator('field_name')` decorator, and then define the function. Function name doesn't matter. Remember, they are class method.

Another approach to add custom Validation is with `Annotated` Type. You have to use `BeforeValidator` and `AfterValidator` from `pydantic` to add custom validation. Both `BeforeValidator` and `AfterValidator` takes validation function as argument.

Other times you may need dependent field validation, that means one field may need to know another field/s before is valid first. Custom validator also receives an argument called **`ValidationInfo`**, which is a dictionary called `data` of all the *only validated* previous fields name and the value. You can access the value of the previous fields using `ValidationInfo.data['field_name']`.

```python title="custom_validator.py" linenums="1"
from pydantic import BaseModel, Field, field_validator, ValidationError, BeforeValidator, AfterValidator, ValidationInfo # (1)!
from typing import Annotated


def cool_before_validator(value): # (2)!
    print(f"🚀 Running before validator for value: {value}")
    if isinstance(value, str) and value.isdigit():
        print(f"🔢 Converting string '{value}' to integer...")
        return int(value)
    else:
        print(f"⚠️ Value '{value}' is not a digit string, skipping conversion and returning 0")
        return 0
    
def say_validated(value): # (3)!
    print(f"✅ Validated value: {value}")
    return value

BoundedInt = Annotated[int, Field(le=100), BeforeValidator(cool_before_validator), AfterValidator(say_validated)] # (4)!

class Model(BaseModel):
    x: int = Field(gt=0, le=100)
    y: int = Field(gt=0, le=100)
    z: BoundedInt
    
    @field_validator('x') # (5)!
    @classmethod # (6)!
    def validate_if_even(cls, value): # (7)!
        print("🎯 Validating if x is even...")
        if value % 2 != 0:
            raise ValueError(f"🤦 x must be an even number, got {value}") # (8)!
        return value
    @field_validator('x')
    @classmethod
    def multiply_by_own(cls, value):
        print(f"✖︎ Multiplying=> {value} by {value}...")
        return value * value
    
    @field_validator('x', 'y') # (9)!
    @classmethod
    def multiply_with_pi(cls, value):
        print(f"🥧 Multiplying {value} with pi...")
        return value * 3.14159
    
    @field_validator('y') # (10)!
    @classmethod
    def validate_if_greater_then_x(cls, value, validated_values: ValidationInfo): # (11)!
        values = validated_values.data # (12)!
        if 'x' in values:
            x_value = values['x']
            print(f"🔍 Validating if y ({value}) is greater than x ({x_value})...")
            if value <= x_value:
                raise ValueError(f"🤦 y must be greater than x, got y={value} and x={x_value}")
        return value
    
    @field_validator('x', 'y', mode='before') # (13)!
    @classmethod
    def not_fifty(cls, value):
        print(f"🚫 Checking if {value} is 50 before validation...")
        if value == 50:
            raise ValueError("❌ Value cannot be 50")
        print(f"✅ {value} is not 50, proceeding with validation...")
        return value
    
model_object_1 = Model(x=4, y=40, z="16") # (14)!
print(model_object_1) # (15)!
try:
    model_object_2 = Model(x="4", y=40, z="Oh my God!") # (16)!
except ValidationError as e:
    print("⚠️ Validation error occurred:")
    print(e)
    
try:
    model_object_3 = Model(x=5, y=5) # (17)!
except ValidationError as e:
    print("⚠️ Validation error occurred:")
    print(e)

```

1. `field_validator` will help to add field level validation, `BeforeValidator` and `AfterValidator` are mostly used when used with Annotated type, `ValidationInfo` from `pydantic` provide information about validated fields of the model.
2. Defining a validation method. Any valid method description will be used here.
3. Another validation method. For Annotated type we can use these.
4. The `BoundedInt` is annotated with field type with `int` and validation with `Field` object. It will also have before and after validator with `BeforeValidator` and `AfterValidator` objects. `BeforeValidator` and `Aftervalidator` will take validation method as argument.
5. For field level validation we need to use `field_validator` decorator. It will take the field name as argument. For more then one field We can add them by seperating them with comma also use `*` to apply validator to all fields. You just need to add a `mode` to specify before and after. By default it's after.
6. Since validators are class method, we need to use `@classmethod` decorator. It's 100% python requirement.
7. A before validator, since it's a class method, we are passing `cls` as the first argument. and the value of the field will be passed as the second argument.
8. We are raising `ValueError` here. It will be considered by Pydantic and ultimately raise a validation error. Othertype of error will be shown up as it is.
9. Here same after validation rule will be applied for both `x` and `y` fields.
10. Field validation for only `y` field. 
11. `ValidationInfo` here represent validated values offered by pydantic.
12. `data` property holds the validated values of the previous fields.
13. `mode` represent if we want to apply the validator before or after the pydantic validation.
14. `z` will be converted to int by the before validator, and x will be validated and transformed by the field validators.
15. The output will be 🚫 Checking if 4 is 50 before validation...✅ 4 is not 50, proceeding with validation...🎯 Validating if x is even...✖︎ Multiplying=> 4 by 4...🥧 Multiplying 16 with pi...🚫 Checking if 40 is 50 before validation...✅ 40 is not 50, proceeding with validation...🥧 Multiplying 40 with pi...🔍 Validating if y (125.6636) is greater than x (50.26544)...🚀 Running before validator for value: 16 🔢 Converting string '16' to integer...✅ Validated value: 16 x=50.26544 y=125.6636 z=16
16. `z` will not be converted here, We will not get any error here, but we will the get the value of `z` = 0. And also the message - ⚠️ Value 'Oh my God!' is not a digit string, skipping conversion and returning 0 ✅ Validated value: 0
17. We will recieve two error here, Value error, 🤦 x must be an even number, got 5 | z Field required

!!! info
    `*` can be used to apply validator to all fields. You just need to add a `mode` to specify before and after. By default it's after.

## Serialization and Deserialization


## Computed Fields

## Complex Models

## Practical Examples

## Hacks

- If the default value is `None` then you have to add the type `None` also. `field: int | None = None`.

## Notes

- `.model_fields_set` gives the name of the field that are set with `non-default` value.
- `.model_json_schema()` gives the json schema of the model.
- `.model_extra` gives the extra fields provided in deserialization.
- `.model_config` gives the configuration of the model.
- `FieldSerializationInfo` from `pydantic` offers different information of the serialization.

## Repo
Checkout the code examples [here](https://github.com/hafiz-bs23/pydantic_v2).