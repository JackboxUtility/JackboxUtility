

# 



<table>
<tbody>

<tr><th>$schema</th><td>http://json-schema.org/draft-07/schema#</td></tr>
</tbody>
</table>

## Properties

<table><thead><tr><th colspan="2">Name</th><th>Type</th></tr></thead><tbody><tr><td colspan="2"><a href="#tags">tags</a></td><td>Array</td></tr><tr><td colspan="2"><a href="#patchscategories">patchsCategories</a></td><td>Array</td></tr><tr><td colspan="2"><a href="#packs">packs</a></td><td>Array</td></tr></tbody></table>



<hr />



## tags


<table>
  <tbody>
    <tr><th>Type</th><td colspan="2">Array</td></tr>
    <tr>
      <th>Required</th>
      <td colspan="2">Yes</td>
    </tr>
    
  </tbody>
</table>



### tags.id


<table>
  <tbody>
    <tr>
      <th>Description</th>
      <td colspan="2">The unique identifier for a tag</td>
    </tr>
    <tr><th>Type</th><td colspan="2">String</td></tr>
    
  </tbody>
</table>




### tags.name


<table>
  <tbody>
    <tr>
      <th>Description</th>
      <td colspan="2">Name of the tag</td>
    </tr>
    <tr><th>Type</th><td colspan="2">String</td></tr>
    
  </tbody>
</table>




### tags.icon


<table>
  <tbody>
    <tr>
      <th>Description</th>
      <td colspan="2">Icon of the tag</td>
    </tr>
    <tr><th>Type</th><td colspan="2">String</td></tr>
    
  </tbody>
</table>




### tags.description


<table>
  <tbody>
    <tr>
      <th>Description</th>
      <td colspan="2">Description of the tag</td>
    </tr>
    <tr><th>Type</th><td colspan="2">String</td></tr>
    
  </tbody>
</table>







## patchsCategories


<table>
  <tbody>
    <tr>
      <th>Description</th>
      <td colspan="2">List of patchs categories found in the all patches table</td>
    </tr>
    <tr><th>Type</th><td colspan="2">Array</td></tr>
    <tr>
      <th>Required</th>
      <td colspan="2">Yes</td>
    </tr>
    
  </tbody>
</table>



### patchsCategories.id


<table>
  <tbody>
    <tr>
      <th>Description</th>
      <td colspan="2">The unique identifier for a patch category</td>
    </tr>
    <tr><th>Type</th><td colspan="2">String</td></tr>
    
  </tbody>
</table>




### patchsCategories.name


<table>
  <tbody>
    <tr>
      <th>Description</th>
      <td colspan="2">Name of the patch category</td>
    </tr>
    <tr><th>Type</th><td colspan="2">String</td></tr>
    
  </tbody>
</table>




### patchsCategories.smallDescription


<table>
  <tbody>
    <tr>
      <th>Description</th>
      <td colspan="2">Small description of the patch category</td>
    </tr>
    <tr><th>Type</th><td colspan="2">String</td></tr>
    
  </tbody>
</table>




### patchsCategories.patchs


<table>
  <tbody>
    <tr>
      <th>Description</th>
      <td colspan="2">List of patchs id in the category. It can be a game patch or a pack patch</td>
    </tr>
    <tr><th>Type</th><td colspan="2">Array</td></tr>
    
  </tbody>
</table>







## packs


<table>
  <tbody>
    <tr><th>Type</th><td colspan="2">Array</td></tr>
    <tr>
      <th>Required</th>
      <td colspan="2">Yes</td>
    </tr>
    
  </tbody>
</table>



### packs.id


<table>
  <tbody>
    <tr>
      <th>Description</th>
      <td colspan="2">The unique identifier for a pack</td>
    </tr>
    <tr><th>Type</th><td colspan="2">String</td></tr>
    
  </tbody>
</table>




### packs.name


<table>
  <tbody>
    <tr><th>Type</th><td colspan="2">String</td></tr>
    
  </tbody>
</table>




### packs.description


<table>
  <tbody>
    <tr><th>Type</th><td colspan="2">String</td></tr>
    
  </tbody>
</table>




### packs.launchers_id


<table>
  <tbody>
    <tr><th>Type</th><td colspan="2">Object</td></tr>
    
  </tbody>
</table>



### packs.launchers_id.steam


<table>
  <tbody>
    <tr><th>Type</th><td colspan="2">String</td></tr>
    
  </tbody>
</table>




### packs.launchers_id.epic


<table>
  <tbody>
    <tr><th>Type</th><td colspan="2">String</td></tr>
    
  </tbody>
</table>





### packs.executables


<table>
  <tbody>
    <tr><th>Type</th><td colspan="2">Object</td></tr>
    
  </tbody>
</table>



### packs.executables.windows


<table>
  <tbody>
    <tr><th>Type</th><td colspan="2">String</td></tr>
    
  </tbody>
</table>




### packs.executables.mac


<table>
  <tbody>
    <tr><th>Type</th><td colspan="2">String</td></tr>
    
  </tbody>
</table>




### packs.executables.linux


<table>
  <tbody>
    <tr><th>Type</th><td colspan="2">String</td></tr>
    
  </tbody>
</table>





### packs.loader


<table>
  <tbody>
    <tr><th>Type</th><td colspan="2">Object</td></tr>
    
  </tbody>
</table>



### packs.loader.path


<table>
  <tbody>
    <tr><th>Type</th><td colspan="2">String</td></tr>
    
  </tbody>
</table>




### packs.loader.version


<table>
  <tbody>
    <tr><th>Type</th><td colspan="2">String</td></tr>
    
  </tbody>
</table>





### packs.configuration


<table>
  <tbody>
    <tr><th>Type</th><td colspan="2">Object</td></tr>
    
  </tbody>
</table>



### packs.configuration.version_origin


<table>
  <tbody>
    <tr><th>Type</th><td colspan="2">String</td></tr>
    
  </tbody>
</table>




### packs.configuration.version_file


<table>
  <tbody>
    <tr><th>Type</th><td colspan="2">String</td></tr>
    
  </tbody>
</table>




### packs.configuration.version_property


<table>
  <tbody>
    <tr><th>Type</th><td colspan="2">String</td></tr>
    
  </tbody>
</table>





### packs.patchs


<table>
  <tbody>
    <tr><th>Type</th><td colspan="2">Array</td></tr>
    
  </tbody>
</table>



### packs.patchs.id


<table>
  <tbody>
    <tr><th>Type</th><td colspan="2">String</td></tr>
    
  </tbody>
</table>




### packs.patchs.name


<table>
  <tbody>
    <tr><th>Type</th><td colspan="2">String</td></tr>
    
  </tbody>
</table>




### packs.patchs.small_description


<table>
  <tbody>
    <tr><th>Type</th><td colspan="2">String</td></tr>
    
  </tbody>
</table>




### packs.patchs.description


<table>
  <tbody>
    <tr><th>Type</th><td colspan="2">String</td></tr>
    
  </tbody>
</table>




### packs.patchs.patch_path


<table>
  <tbody>
    <tr><th>Type</th><td colspan="2">String</td></tr>
    
  </tbody>
</table>




### packs.patchs.configuration


<table>
  <tbody>
    <tr><th>Type</th><td colspan="2">Object</td></tr>
    
  </tbody>
</table>



### packs.patchs.configuration.version_origin


<table>
  <tbody>
    <tr><th>Type</th><td colspan="2">String</td></tr>
    
  </tbody>
</table>




### packs.patchs.configuration.version_file


<table>
  <tbody>
    <tr><th>Type</th><td colspan="2">String</td></tr>
    
  </tbody>
</table>




### packs.patchs.configuration.version_property


<table>
  <tbody>
    <tr><th>Type</th><td colspan="2">String</td></tr>
    
  </tbody>
</table>





### packs.patchs.components


<table>
  <tbody>
    <tr><th>Type</th><td colspan="2">Array</td></tr>
    
  </tbody>
</table>



### packs.patchs.components.id


<table>
  <tbody>
    <tr><th>Type</th><td colspan="2">String</td></tr>
    
  </tbody>
</table>




### packs.patchs.components.linked_game


<table>
  <tbody>
    <tr><th>Type</th><td colspan="2">String</td></tr>
    
  </tbody>
</table>




### packs.patchs.components.name


<table>
  <tbody>
    <tr><th>Type</th><td colspan="2">String</td></tr>
    
  </tbody>
</table>




### packs.patchs.components.description


<table>
  <tbody>
    <tr><th>Type</th><td colspan="2">String</td></tr>
    
  </tbody>
</table>




### packs.patchs.components.authors


<table>
  <tbody>
    <tr><th>Type</th><td colspan="2">String</td></tr>
    
  </tbody>
</table>




### packs.patchs.components.small_description


<table>
  <tbody>
    <tr><th>Type</th><td colspan="2">String</td></tr>
    
  </tbody>
</table>




### packs.patchs.components.patch_type


<table>
  <tbody>
    <tr><th>Type</th><td colspan="2">Object</td></tr>
    
  </tbody>
</table>



### packs.patchs.components.patch_type.game_text


<table>
  <tbody>
    <tr><th>Type</th><td colspan="2">Boolean</td></tr>
    
  </tbody>
</table>




### packs.patchs.components.patch_type.game_assets


<table>
  <tbody>
    <tr><th>Type</th><td colspan="2">Boolean</td></tr>
    
  </tbody>
</table>




### packs.patchs.components.patch_type.game_subtitles


<table>
  <tbody>
    <tr><th>Type</th><td colspan="2">Boolean</td></tr>
    
  </tbody>
</table>




### packs.patchs.components.patch_type.website


<table>
  <tbody>
    <tr><th>Type</th><td colspan="2">Boolean</td></tr>
    
  </tbody>
</table>




### packs.patchs.components.patch_type.audios


<table>
  <tbody>
    <tr><th>Type</th><td colspan="2">Boolean</td></tr>
    
  </tbody>
</table>







### packs.games


<table>
  <tbody>
    <tr><th>Type</th><td colspan="2">Array</td></tr>
    
  </tbody>
</table>



### packs.games.id


<table>
  <tbody>
    <tr><th>Type</th><td colspan="2">String</td></tr>
    
  </tbody>
</table>




### packs.games.name


<table>
  <tbody>
    <tr><th>Type</th><td colspan="2">String</td></tr>
    
  </tbody>
</table>




### packs.games.background


<table>
  <tbody>
    <tr><th>Type</th><td colspan="2">String</td></tr>
    
  </tbody>
</table>




### packs.games.path


<table>
  <tbody>
    <tr><th>Type</th><td colspan="2">String</td></tr>
    
  </tbody>
</table>




### packs.games.game_info


<table>
  <tbody>
    <tr><th>Type</th><td colspan="2">Object</td></tr>
    
  </tbody>
</table>



### packs.games.game_info.players


<table>
  <tbody>
    <tr><th>Type</th><td colspan="2">Object</td></tr>
    
  </tbody>
</table>



### packs.games.game_info.players.min


<table>
  <tbody>
    <tr><th>Type</th><td colspan="2">Integer</td></tr>
    
  </tbody>
</table>




### packs.games.game_info.players.max


<table>
  <tbody>
    <tr><th>Type</th><td colspan="2">Integer</td></tr>
    
  </tbody>
</table>





### packs.games.game_info.length


<table>
  <tbody>
    <tr><th>Type</th><td colspan="2">String</td></tr>
    
  </tbody>
</table>




### packs.games.game_info.type


<table>
  <tbody>
    <tr><th>Type</th><td colspan="2">String</td></tr>
    
  </tbody>
</table>




### packs.games.game_info.translation


<table>
  <tbody>
    <tr><th>Type</th><td colspan="2">String</td></tr>
    
  </tbody>
</table>




### packs.games.game_info.tagline


<table>
  <tbody>
    <tr><th>Type</th><td colspan="2">String</td></tr>
    
  </tbody>
</table>




### packs.games.game_info.small_description


<table>
  <tbody>
    <tr><th>Type</th><td colspan="2">String</td></tr>
    
  </tbody>
</table>




### packs.games.game_info.description


<table>
  <tbody>
    <tr><th>Type</th><td colspan="2">String</td></tr>
    
  </tbody>
</table>




### packs.games.game_info.images


<table>
  <tbody>
    <tr><th>Type</th><td colspan="2">Array</td></tr>
    
  </tbody>
</table>




### packs.games.game_info.tags


<table>
  <tbody>
    <tr><th>Type</th><td colspan="2">Array</td></tr>
    
  </tbody>
</table>





### packs.games.loader


<table>
  <tbody>
    <tr><th>Type</th><td colspan="2">Object</td></tr>
    
  </tbody>
</table>



### packs.games.loader.path


<table>
  <tbody>
    <tr><th>Type</th><td colspan="2">String</td></tr>
    
  </tbody>
</table>




### packs.games.loader.version


<table>
  <tbody>
    <tr><th>Type</th><td colspan="2">String</td></tr>
    
  </tbody>
</table>





### packs.games.patchs


<table>
  <tbody>
    <tr><th>Type</th><td colspan="2">Array</td></tr>
    
  </tbody>
</table>



### packs.games.patchs.id


<table>
  <tbody>
    <tr><th>Type</th><td colspan="2">String</td></tr>
    
  </tbody>
</table>




### packs.games.patchs.name


<table>
  <tbody>
    <tr><th>Type</th><td colspan="2">String</td></tr>
    
  </tbody>
</table>




### packs.games.patchs.small_description


<table>
  <tbody>
    <tr><th>Type</th><td colspan="2">String</td></tr>
    
  </tbody>
</table>




### packs.games.patchs.description


<table>
  <tbody>
    <tr><th>Type</th><td colspan="2">String</td></tr>
    
  </tbody>
</table>




### packs.games.patchs.version


<table>
  <tbody>
    <tr><th>Type</th><td colspan="2">String</td></tr>
    
  </tbody>
</table>




### packs.games.patchs.authors


<table>
  <tbody>
    <tr><th>Type</th><td colspan="2">String</td></tr>
    
  </tbody>
</table>




### packs.games.patchs.patch_path


<table>
  <tbody>
    <tr><th>Type</th><td colspan="2">String</td></tr>
    
  </tbody>
</table>




### packs.games.patchs.patch_type


<table>
  <tbody>
    <tr><th>Type</th><td colspan="2">Object</td></tr>
    
  </tbody>
</table>



### packs.games.patchs.patch_type.game_text


<table>
  <tbody>
    <tr><th>Type</th><td colspan="2">Boolean</td></tr>
    
  </tbody>
</table>




### packs.games.patchs.patch_type.game_assets


<table>
  <tbody>
    <tr><th>Type</th><td colspan="2">Boolean</td></tr>
    
  </tbody>
</table>




### packs.games.patchs.patch_type.game_subtitles


<table>
  <tbody>
    <tr><th>Type</th><td colspan="2">Boolean</td></tr>
    
  </tbody>
</table>




### packs.games.patchs.patch_type.website


<table>
  <tbody>
    <tr><th>Type</th><td colspan="2">Boolean</td></tr>
    
  </tbody>
</table>




### packs.games.patchs.patch_type.audios


<table>
  <tbody>
    <tr><th>Type</th><td colspan="2">Boolean</td></tr>
    
  </tbody>
</table>






### packs.games.icon


<table>
  <tbody>
    <tr><th>Type</th><td colspan="2">String</td></tr>
    
  </tbody>
</table>





### packs.icon


<table>
  <tbody>
    <tr><th>Type</th><td colspan="2">String</td></tr>
    
  </tbody>
</table>




### packs.background


<table>
  <tbody>
    <tr><th>Type</th><td colspan="2">String</td></tr>
    
  </tbody>
</table>











<hr />

## Schema
```
{
    "$schema": "http://json-schema.org/draft-07/schema#",
    "type": "object",
    "properties": {
        "tags": {
            "type": "array",
            "items": {
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
        },
        "patchsCategories": {
            "type": "array",
            "description": "List of patchs categories found in the all patches table",
            "items": {
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
        },
        "packs": {
            "type": "array",
            "items": {
                "type": "object",
                "properties": {
                    "id": {
                        "description": "The unique identifier for a pack",
                        "type": "string"
                    },
                    "name": {
                        "type": "string"
                    },
                    "description": {
                        "type": "string"
                    },
                    "launchers_id": {
                        "type": "object",
                        "properties": {
                            "steam": {
                                "type": "string"
                            },
                            "epic": {
                                "type": "string"
                            }
                        },
                        "required": [
                            "steam",
                            "epic"
                        ]
                    },
                    "executables": {
                        "type": "object",
                        "properties": {
                            "windows": {
                                "type": "string"
                            },
                            "mac": {
                                "type": "string"
                            },
                            "linux": {
                                "type": "string"
                            }
                        },
                        "required": [
                            "windows",
                            "mac",
                            "linux"
                        ]
                    },
                    "loader": {
                        "type": "object",
                        "properties": {
                            "path": {
                                "type": "string"
                            },
                            "version": {
                                "type": "string"
                            }
                        },
                        "required": [
                            "path",
                            "version"
                        ]
                    },
                    "configuration": {
                        "type": "object",
                        "properties": {
                            "version_origin": {
                                "type": "string"
                            },
                            "version_file": {
                                "type": "string"
                            },
                            "version_property": {
                                "type": "string"
                            }
                        },
                        "required": [
                            "version_origin",
                            "version_file",
                            "version_property"
                        ]
                    },
                    "patchs": {
                        "type": "array",
                        "items": {
                            "type": "object",
                            "properties": {
                                "id": {
                                    "type": "string"
                                },
                                "name": {
                                    "type": "string"
                                },
                                "small_description": {
                                    "type": "string"
                                },
                                "description": {
                                    "type": "string"
                                },
                                "patch_path": {
                                    "type": "string"
                                },
                                "configuration": {
                                    "type": "object",
                                    "properties": {
                                        "version_origin": {
                                            "type": "string"
                                        },
                                        "version_file": {
                                            "type": "string"
                                        },
                                        "version_property": {
                                            "type": "string"
                                        }
                                    },
                                    "required": [
                                        "version_origin",
                                        "version_file",
                                        "version_property"
                                    ]
                                },
                                "components": {
                                    "type": "array",
                                    "items": {
                                        "type": "object",
                                        "properties": {
                                            "id": {
                                                "type": "string"
                                            },
                                            "linked_game": {
                                                "type": "string"
                                            },
                                            "name": {
                                                "type": "string"
                                            },
                                            "description": {
                                                "type": "string"
                                            },
                                            "authors": {
                                                "type": "string"
                                            },
                                            "small_description": {
                                                "type": "string"
                                            },
                                            "patch_type": {
                                                "type": "object",
                                                "properties": {
                                                    "game_text": {
                                                        "type": "boolean"
                                                    },
                                                    "game_assets": {
                                                        "type": "boolean"
                                                    },
                                                    "game_subtitles": {
                                                        "type": "boolean"
                                                    },
                                                    "website": {
                                                        "type": "boolean"
                                                    },
                                                    "audios": {
                                                        "type": "boolean"
                                                    }
                                                },
                                                "required": [
                                                    "game_text",
                                                    "game_assets",
                                                    "game_subtitles",
                                                    "website",
                                                    "audios"
                                                ]
                                            }
                                        },
                                        "required": [
                                            "id",
                                            "linked_game",
                                            "name",
                                            "description",
                                            "authors",
                                            "small_description",
                                            "patch_type"
                                        ]
                                    }
                                }
                            },
                            "required": [
                                "id",
                                "name",
                                "small_description",
                                "description",
                                "patch_path",
                                "configuration",
                                "components"
                            ]
                        }
                    },
                    "games": {
                        "type": "array",
                        "items": {
                            "type": "object",
                            "properties": {
                                "id": {
                                    "type": "string"
                                },
                                "name": {
                                    "type": "string"
                                },
                                "background": {
                                    "type": "string"
                                },
                                "path": {
                                    "type": "string"
                                },
                                "game_info": {
                                    "type": "object",
                                    "properties": {
                                        "players": {
                                            "type": "object",
                                            "properties": {
                                                "min": {
                                                    "type": "integer"
                                                },
                                                "max": {
                                                    "type": "integer"
                                                }
                                            },
                                            "required": [
                                                "min",
                                                "max"
                                            ]
                                        },
                                        "length": {
                                            "type": "string"
                                        },
                                        "type": {
                                            "type": "string"
                                        },
                                        "translation": {
                                            "type": "string"
                                        },
                                        "tagline": {
                                            "type": "string"
                                        },
                                        "small_description": {
                                            "type": "string"
                                        },
                                        "description": {
                                            "type": "string"
                                        },
                                        "images": {
                                            "type": "array",
                                            "items": {
                                                "type": "string"
                                            }
                                        },
                                        "tags": {
                                            "type": "array",
                                            "items": {
                                                "type": "string"
                                            }
                                        }
                                    },
                                    "required": [
                                        "players",
                                        "length",
                                        "type",
                                        "translation",
                                        "tagline",
                                        "small_description",
                                        "description",
                                        "images",
                                        "tags"
                                    ]
                                },
                                "loader": {
                                    "type": "object",
                                    "properties": {
                                        "path": {
                                            "type": "string"
                                        },
                                        "version": {
                                            "type": "string"
                                        }
                                    },
                                    "required": [
                                        "path",
                                        "version"
                                    ]
                                },
                                "patchs": {
                                    "type": "array",
                                    "items": {
                                        "type": "object",
                                        "properties": {
                                            "id": {
                                                "type": "string"
                                            },
                                            "name": {
                                                "type": "string"
                                            },
                                            "small_description": {
                                                "type": "string"
                                            },
                                            "description": {
                                                "type": "string"
                                            },
                                            "version": {
                                                "type": "string"
                                            },
                                            "authors": {
                                                "type": "string"
                                            },
                                            "patch_path": {
                                                "type": "string"
                                            },
                                            "patch_type": {
                                                "type": "object",
                                                "properties": {
                                                    "game_text": {
                                                        "type": "boolean"
                                                    },
                                                    "game_assets": {
                                                        "type": "boolean"
                                                    },
                                                    "game_subtitles": {
                                                        "type": "boolean"
                                                    },
                                                    "website": {
                                                        "type": "boolean"
                                                    },
                                                    "audios": {
                                                        "type": "boolean"
                                                    }
                                                },
                                                "required": [
                                                    "game_text",
                                                    "game_assets",
                                                    "game_subtitles",
                                                    "website",
                                                    "audios"
                                                ]
                                            }
                                        },
                                        "required": [
                                            "id",
                                            "name",
                                            "small_description",
                                            "description",
                                            "version",
                                            "authors",
                                            "patch_path",
                                            "patch_type"
                                        ]
                                    }
                                },
                                "icon": {
                                    "type": "string"
                                }
                            },
                            "required": [
                                "id",
                                "name",
                                "background",
                                "path",
                                "game_info",
                                "loader",
                                "patchs",
                                "icon"
                            ]
                        }
                    },
                    "icon": {
                        "type": "string"
                    },
                    "background": {
                        "type": "string"
                    }
                },
                "required": [
                    "id",
                    "name",
                    "description",
                    "launchers_id",
                    "executables",
                    "loader",
                    "configuration",
                    "patchs",
                    "games",
                    "icon",
                    "background"
                ]
            }
        }
    },
    "required": [
        "tags",
        "patchsCategories",
        "packs"
    ]
}
```


