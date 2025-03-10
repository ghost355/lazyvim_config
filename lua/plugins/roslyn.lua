return {
  {
    "seblj/roslyn.nvim",
    ft = "cs",
    -- enabled = false,
    opts = {
      config = {
        on_attach = function(client, bufnr)
          -- let client know we got this
          client.server_capabilities = vim.tbl_deep_extend("force", client.server_capabilities, {
            semanticTokensProvider = {
              full = true,
            },
          })

          -- Save the original request method
          local original_request = client.request

          -- Override the client's request method
          client.request = function(method, params, handler, ctx, config)
            -- Log all LSP requests to a file
            -- local log_file = io.open("/tmp/nvim_lsp_debug.log", "a")
            -- if log_file then
            --   log_file:write(string.format("\n=== LSP Client Request at %s ===\n", os.date()))
            --   log_file:write("method: " .. method .. "\n")
            --   log_file:write("params: " .. vim.inspect(params) .. "\n")
            --   log_file:write("================================\n")
            --   log_file:close()
            -- end

            if method == "textDocument/semanticTokens/full" then
              -- Modify the request to a range request covering the entire document

              -- Convert URI to buffer number
              local target_bufnr = vim.uri_to_bufnr(params.textDocument.uri)

              -- Ensure the buffer is loaded
              if not vim.api.nvim_buf_is_loaded(target_bufnr) then
                vim.notify("[LSP] Buffer not loaded for URI: " .. params.textDocument.uri, vim.log.levels.WARN)
                return original_request(method, params, handler, ctx, config)
              end

              -- Get the total number of lines in the buffer
              local line_count = vim.api.nvim_buf_line_count(target_bufnr)

              -- Get the last line's content
              local last_line = vim.api.nvim_buf_get_lines(target_bufnr, line_count - 1, line_count, true)[1] or ""

              -- Calculate the end character (0-based index)
              local end_character = #last_line

              -- Construct the range
              local range = {
                start = { line = 0, character = 0 },
                ["end"] = { line = line_count - 1, character = end_character },
              }

              -- Construct the new params for the range request
              local new_params = {
                textDocument = params.textDocument,
                range = range,
              }

              -- Log the modification
              -- local log_file_range = io.open("/tmp/nvim_lsp_debug.log", "a")
              -- if log_file_range then
              --   log_file_range:write("Modified to 'textDocument/semanticTokens/range' with range: " .. vim.inspect(range) .. "\n")
              --   log_file_range:close()
              -- end

              -- Send the modified range request
              return original_request("textDocument/semanticTokens/range", new_params, handler, ctx, config)
            end

            -- Call the original request method for all other methods
            return original_request(method, params, handler, ctx, config)
          end
        end,
        settings = {
          ["csharp|inlay_hints"] = {
            csharp_enable_inlay_hints_for_implicit_object_creation = true,
            csharp_enable_inlay_hints_for_implicit_variable_types = true,
            csharp_enable_inlay_hints_for_lambda_parameter_types = true,
            csharp_enable_inlay_hints_for_types = true,
            dotnet_enable_inlay_hints_for_indexer_parameters = true,
            dotnet_enable_inlay_hints_for_literal_parameters = true,
            dotnet_enable_inlay_hints_for_object_creation_parameters = true,
            dotnet_enable_inlay_hints_for_other_parameters = true,
            dotnet_enable_inlay_hints_for_parameters = true,
            dotnet_suppress_inlay_hints_for_parameters_that_differ_only_by_suffix = true,
            dotnet_suppress_inlay_hints_for_parameters_that_match_argument_name = true,
            dotnet_suppress_inlay_hints_for_parameters_that_match_method_intent = true,
          },
          ["csharp|code_lens"] = {
            dotnet_enable_references_code_lens = true,
            dotnet_enable_tests_code_lens = true,
          },
          ["csharp|completion"] = {
            dotnet_show_completion_items_from_unimported_namespaces = true,
            dotnet_show_name_completion_suggestions = true,
          },
          ["csharp|background_analysis"] = {
            background_analysis_dotnet_compiler_diagnostics_scope = "fullSolution",
            background_analysis_dotnet_analyzers_diagnostics_scope = "fullSolution",
          },
          ["csharp|symbol_search"] = {
            dotnet_search_reference_assemblies = true,
          },
        },
      },
    },
  },
  {
    "nvim-treesitter/nvim-treesitter",
    opts = { ensure_installed = { "c_sharp" } },
  },
  {
    "williamboman/mason.nvim",
    opts = { ensure_installed = { "csharpier" } },
  },
  {
    "nvimtools/none-ls.nvim",
    optional = true,
    opts = function(_, opts)
      local nls = require("null-ls")
      opts.sources = opts.sources or {}
      table.insert(opts.sources, nls.builtins.formatting.csharpier)
    end,
  },
  {
    "stevearc/conform.nvim",
    optional = true,
    opts = {
      formatters_by_ft = {
        cs = { "csharpier" },
      },
      formatters = {
        csharpier = {
          command = "dotnet-csharpier",
          args = { "--write-stdout" },
        },
      },
    },
  },
  {
    "nvim-treesitter/nvim-treesitter",
    opts = { ensure_installed = { "c_sharp" } },
  },
  {
    "williamboman/mason.nvim",
    opts = { ensure_installed = { "csharpier" } },
  },
  {
    "Issafalcon/neotest-dotnet",
  },
  {
    "nvimtools/none-ls.nvim",
    optional = true,
    opts = function(_, opts)
      local nls = require("null-ls")
      opts.sources = opts.sources or {}
      table.insert(opts.sources, nls.builtins.formatting.csharpier)
    end,
  },
  {
    "stevearc/conform.nvim",
    optional = true,
    opts = {
      formatters_by_ft = {
        cs = { "csharpier" },
      },
      formatters = {
        csharpier = {
          command = "dotnet-csharpier",
          args = { "--write-stdout" },
        },
      },
    },
  },
  {
    "mfussenegger/nvim-dap",
    optional = true,
    opts = function()
      local dap = require("dap")
      if not dap.adapters["netcoredbg"] then
        require("dap").adapters["netcoredbg"] = {
          type = "executable",
          command = vim.fn.exepath("netcoredbg"),
          args = { "--interpreter=vscode" },
          options = {
            detached = false,
          },
        }
      end
      for _, lang in ipairs({ "cs", "fsharp", "vb" }) do
        if not dap.configurations[lang] then
          dap.configurations[lang] = {
            {
              type = "netcoredbg",
              name = "Launch file",
              request = "launch",
              ---@diagnostic disable-next-line: redundant-parameter
              program = function()
                return vim.fn.input("Path to dll: ", vim.fn.getcwd() .. "/", "file")
              end,
              cwd = "${workspaceFolder}",
            },
          }
        end
      end
    end,
  },
  {
    "nvim-neotest/neotest",
    optional = true,
    dependencies = {
      "Issafalcon/neotest-dotnet",
    },
    opts = {
      adapters = {
        ["neotest-dotnet"] = {
          -- Here we can set options for neotest-dotnet
        },
      },
    },
  },

  {
    "mfussenegger/nvim-dap",
    optional = true,
    opts = function()
      local dap = require("dap")
      if not dap.adapters["netcoredbg"] then
        require("dap").adapters["netcoredbg"] = {
          type = "executable",
          command = vim.fn.exepath("netcoredbg"),
          args = { "--interpreter=vscode" },
          options = {
            detached = false,
          },
        }
      end

      for _, lang in ipairs({ "cs", "fsharp", "vb" }) do
        if not dap.configurations[lang] then
          dap.configurations[lang] = {
            {
              type = "netcoredbg",
              name = "Launch file",
              request = "launch",
              ---@diagnostic disable-next-line: redundant-parameter
              program = function()
                return vim.fn.input("Path to dll: ", vim.fn.getcwd() .. "/bin/Debug/net9.0/", "file")
              end,
              cwd = "${workspaceFolder}",
            },
          }
        end
      end
    end,
  },
}
