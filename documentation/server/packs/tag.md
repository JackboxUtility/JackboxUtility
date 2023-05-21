

# Tag

<p>A tag is a label that can be attached to a game</p>

<table>
<tbody>
<tr><th>$id</th><td>packs/tag.json</td></tr>
<tr><th>$schema</th><td>http://json-schema.org/draft-07/schema#</td></tr>
</tbody>
</table>

## Properties

<table><thead><tr><th colspan="2">Name</th><th>Type</th></tr></thead><tbody><tr><td colspan="2"><a href="#id">id</a></td><td>String</td></tr><tr><td colspan="2"><a href="#name">name</a></td><td>String</td></tr><tr><td colspan="2"><a href="#icon">icon</a></td><td>String</td></tr><tr><td colspan="2"><a href="#description">description</a></td><td>String</td></tr></tbody></table>



<hr />



## id


<table>
  <tbody>
    <tr>
      <th>Description</th>
      <td colspan="2">The unique identifier for a tag</td>
    </tr>
    <tr><th>Type</th><td colspan="2">String</td></tr>
    <tr>
      <th>Required</th>
      <td colspan="2">Yes</td>
    </tr>
    
  </tbody>
</table>






## name


<table>
  <tbody>
    <tr>
      <th>Description</th>
      <td colspan="2">Name of the tag</td>
    </tr>
    <tr><th>Type</th><td colspan="2">String</td></tr>
    <tr>
      <th>Required</th>
      <td colspan="2">Yes</td>
    </tr>
    
  </tbody>
</table>






## icon


<table>
  <tbody>
    <tr>
      <th>Description</th>
      <td colspan="2">Icon of the tag</td>
    </tr>
    <tr><th>Type</th><td colspan="2">String</td></tr>
    <tr>
      <th>Required</th>
      <td colspan="2">Yes</td>
    </tr>
    
  </tbody>
</table>






## description


<table>
  <tbody>
    <tr>
      <th>Description</th>
      <td colspan="2">Description of the tag</td>
    </tr>
    <tr><th>Type</th><td colspan="2">String</td></tr>
    <tr>
      <th>Required</th>
      <td colspan="2">Yes</td>
    </tr>
    
  </tbody>
</table>










<hr />

## Schema
```
{
    "$schema": "http://json-schema.org/draft-07/schema#",
    "$id": "packs/tag.json",
    "title": "Tag",
    "description": "A tag is a label that can be attached to a game",
    "type": "object",
    "properties": {
        "id": {
            "description": "The unique identifier for a tag",
            "type": "string"
        },
        "name": {
            "description": "Name of the tag",
            "type": "string"
        },
        "icon": {
            "description": "Icon of the tag",
            "type": "string"
        },
        "description": {
            "description": "Description of the tag",
            "type": "string"
        }
    },
    "required": [
        "id",
        "name",
        "icon",
        "description"
    ]
}
```


