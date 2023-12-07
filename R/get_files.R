path <- fs::path(
  r'(D:\Git\d3-resources-1\ca_customvis-master)'
)

df_files <- fs::dir_ls(
  path,
  recurse = TRUE,
  type = "file"
) |>
  tibble::as_tibble_col(
    column_name = "file_path"
  ) |>
  dplyr::mutate(
    dir = fs::path_dir(
      file_path
    ),
    file = fs::path_file(
      file_path
    )
  )

df_vizdef_main <- df_files |>
  dplyr::filter(
    file %in% c(
      "vizdef.xml",
      "Main.ts"
    )
  ) |>
  dplyr::mutate(
    last_dir = dplyr::case_when(
      file == "vizdef.xml" ~ stringr::str_split_i(
        dir,
        pattern = r'(/)',
        i = -1
      ),
      file == "Main.ts" ~ stringr::str_split_i(
        dir,
        pattern = r'(/)',
        i = -2
      ),
      .default = "test"
    ),
    new_file = paste(
      last_dir,
      file,
      sep = '_'
    ),
    new_path = here::here(
      "output",
      new_file
    )
  )

fs::file_copy(
  path = df_vizdef_main[["file_path"]],
  new_path = df_vizdef_main[["new_path"]],
  overwrite = TRUE
)
