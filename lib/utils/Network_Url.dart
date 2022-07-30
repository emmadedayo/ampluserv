

class Network_Url  {
  static  const BASE_URL = "http://api.ampluserv.com/index.php/";
  static  const IMAGE_URL = "http://api.ampluserv.com/estate_api/storage/upload/";

  PostService(serviceStr) {
    return BASE_URL + 'api/' + serviceStr;
  }

  GetService(serviceStr) {
    return BASE_URL + 'api/' + serviceStr;
  }

  GetbyID(serviceStr,id) {
    return BASE_URL + 'api/' + serviceStr + '/' + id;
  }

  ImageService(serviceStr) {
    return IMAGE_URL + serviceStr;
  }
}
