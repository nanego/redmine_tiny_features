Deface::Override.new(
  :virtual_path  => 'users/index',
  :name          => 'add-quick-search-to-users-index',
  :insert_after  => 'h2',
  :partial       => 'tiny_features/users/quick_search'
)
