# Github Actions

Tips for testing GH actions

## Broken Link Check

To check the broken links in the rendered pages the action `broken-link-check` uses the [blc](https://github.com/stevenvachon/broken-link-checker) command. Install as needed then run:

```shell
npx blc "https://ledapplications.github.io/lehd-schema/lehd_shapefiles.html" --exclude https://ledapplications.github.io/lehd-schema/lehd_shp_*.zip
```
