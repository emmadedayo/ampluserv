import 'package:ampluserv/utils/FetchDataException.dart';
import 'package:ampluserv/models/ampProduct.dart';
import 'package:ampluserv/utils/rest_ds.dart';

abstract class ProductContract {
  void onSuccess(List<ampProductModel> items);
  void onError(FetchDataException e);
}

class ProductPresenter {
  ProductContract _view;
  RestDatasource api = new RestDatasource();
  ProductPresenter(this._view);

  getPrayer(data,myString) {
    api.AmpProduct(data,myString).then((data) {
      _view.onSuccess(data);
    }).catchError((Object error) =>
        _view.onError(new FetchDataException(error.toString())));
  }
}
