

# 



<table>
<tbody>
<tr><th>$id</th><td>packs/index.json</td></tr>
<tr><th>$schema</th><td>http://json-schema.org/draft-07/schema#</td></tr>
</tbody>
</table>

## Properties

<table><thead><tr><th colspan="2">Name</th><th>Type</th></tr></thead><tbody><tr><td colspan="2"><a href="#tags">tags</a></td><td>Array [<a href="tag.html">Tag</a>]</td></tr><tr><td colspan="2"><a href="#patchscategories">patchsCategories</a></td><td>Array [<a href="patchCategory.html">patchCategory.html</a>]</td></tr></tbody></table>



<hr />



## tags

  <p>Defined in <a href="tag.html">tag.html</a></p>

<table>
  <tbody>
    <tr><th>Type</th><td colspan="2">Array [<a href="tag.html">Tag</a>]</td></tr>
    <tr>
      <th>Required</th>
      <td colspan="2">No</td>
    </tr>
    
  </tbody>
</table>






## patchsCategories

  <p>Defined in <a href="patchCategory.html">patchCategory.html</a></p>

<table>
  <tbody>
    <tr>
      <th>Description</th>
      <td colspan="2">List of patchs categories found in the all patches table</td>
    </tr>
    <tr><th>Type</th><td colspan="2">Array [<a href="patchCategory.html">patchCategory.html</a>]</td></tr>
    <tr>
      <th>Required</th>
      <td colspan="2">No</td>
    </tr>
    
  </tbody>
</table>










<hr />

## Schema
```
{
    "$schema": "http://json-schema.org/draft-07/schema#",
    "$id": "packs/index.json",
    "type": "object",
    "properties": {
        "tags": {
            "type": "array",
            "items": {
                "description": "Tag",
                "$ref": "tag.json"
            }
        },
        "patchsCategories": {
            "type": "array",
            "description": "List of patchs categories found in the all patches table",
            "items": {
                "description": "Patch category",
                "$ref": "patchCategory.json"
            }
        }
    }
}
```


