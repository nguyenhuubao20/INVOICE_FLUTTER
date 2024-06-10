String getRoleText(int role) {
  switch (role) {
    case 0:
      return 'Brand Admin';
    case 1:
      return 'System Admin';
    case 2:
      return 'Organization Admin';
    default:
      return 'Unknown Role';
  }
}
