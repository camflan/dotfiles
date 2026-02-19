-- TODO: pull override from env?
local KUBERNETES_SCHEMA_VERSION = "v1.26.9"
local KUBERNETES_SCHEMA_VARIANT = "standalone-strict"

local schemastore = require("schemastore")

return {
  settings = {
    redhat = { telemetry = { enabled = false } },
    yaml = {
      completion = true,
      format = { enable = false },
      hover = true,
      schemas = schemastore.yaml.schemas({
        extra = {
          {
            description = "",
            fileMatch = { "*.k8s.yaml" },
            name = "Kubernetes " .. KUBERNETES_SCHEMA_VERSION,
            url = "https://raw.githubusercontent.com/yannh/kubernetes-json-schema/master/"
              .. KUBERNETES_SCHEMA_VERSION
              .. "-"
              .. KUBERNETES_SCHEMA_VARIANT
              .. "/all.json",
          },
        },
      }),
      schemaStore = {
        -- disable built-in schemastore so we can
        -- use b00/schemastore
        enable = false,
        url = "",
      },
      validate = true,
    },
  },
}
