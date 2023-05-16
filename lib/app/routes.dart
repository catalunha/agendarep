enum AppPage {
  splash('/', 'splash'),
  login('/login', 'login'),
  home('/home', 'splash'),
  // /home/region_save (segue path com go)
  regionSave('region_save', 'regionSave'),
  // /home/region_search (segue path com go)
  regionSearch('region_search', 'regionSearch'),
  // /home/region_search/list (segue path com go)
  regionSearchList('region_search_list', 'regionSearchList'),
  // ...region-select (aleatorio com push)
  regionSelect('region-select', 'regionSelect'),
  // ...region-view (aleatorio com push)
  regionView('region-view', 'regionView'),

  addressSave('address_save', 'addressSave'),
  addressSearch('address_search', 'addressSearch'),
  addressSearchList('address_search_list', 'addressSearchList'),
  addressSelect('address-select', 'addressSelect'),
  addressView('address-view', 'addressView'),

  secretarySave('secretary_save', 'secretarySave'),
  secretarySearch('secretary_search', 'secretarySearch'),
  secretarySearchList('secretary_search_list', 'secretarySearchList'),
  secretarySelect('secretary-select', 'secretarySelect'),
  secretaryView('secretary-view', 'secretaryView');

  final String path;
  final String name;
  const AppPage(this.path, this.name);
}
