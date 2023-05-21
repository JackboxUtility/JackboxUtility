

# 



<table>
<tbody>
<tr><th>$id</th><td>packs/patchCategory.json</td></tr>
<tr><th>$schema</th><td>http://json-schema.org/draft-07/schema#</td></tr>
</tbody>
</table>

## Properties

<table><thead><tr><th colspan="2">Name</th><th>Type</th></tr></thead><tbody><tr><td colspan="2"><a href="#id">id</a></td><td>String</td></tr><tr><td colspan="2"><a href="#name">name</a></td><td>String</td></tr><tr><td colspan="2"><a href="#smalldescription">smallDescription</a></td><td>String</td></tr><tr><td colspan="2"><a href="#patchs">patchs</a></td><td>Array</td></tr></tbody></table>



<hr />



## id


<table>
  <tbody>
    <tr>
      <th>Description</th>
      <td colspan="2">The unique identifier for a patch category</td>
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
      <td colspan="2">Name of the patch category</td>
    </tr>
    <tr><th>Type</th><td colspan="2">String</td></tr>
    <tr>
      <th>Required</th>
      <td colspan="2">Yes</td>
    </tr>
    
  </tbody>
</table>






## smallDescription


<table>
  <tbody>
    <tr>
      <th>Description</th>
      <td colspan="2">Small description of the patch category</td>
    </tr>
    <tr><th>Type</th><td colspan="2">String</td></tr>
    <tr>
      <th>Required</th>
      <td colspan="2">Yes</td>
    </tr>
    
  </tbody>
</table>






## patchs


<table>
  <tbody>
    <tr>
      <th>Description</th>
      <td colspan="2">List of patchs id in the category. It can be a game patch or a pack patch</td>
    </tr>
    <tr><th>Type</th><td colspan="2">Array</td></tr>
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
    "$id": "packs/patchCategory.json",
    "type": "object",
    "properties": {
        "id": {
            "description": "The unique identifier for a patch category",
            "type": "string"
        },
        "name": {
            "description": "Name of the patch category",
            "type": "string"
        },
        "smallDescription": {
            "description": "Small description of the patch category",
            "type": "string"
        },
        "patchs": {
            "description": "List of patchs id in the category. It can be a game patch or a pack patch",
            "type": "array",
            "items": {
                "description": "Patch id",
                "type": "string"
            }
        }
    },
    "required": [
        "id",
        "name",
        "smallDescription",
        "patchs"
    ]
}
```


