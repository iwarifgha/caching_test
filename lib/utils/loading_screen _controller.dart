typedef CloseLoadingDialog = bool Function();
typedef UpdateLoadingDialog = bool Function(String text);

class LoadingScreenController{
  CloseLoadingDialog close;
  UpdateLoadingDialog update;

  LoadingScreenController({
    required this.update,
    required this.close
});
}