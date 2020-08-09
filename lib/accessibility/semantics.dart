import 'package:flutter/material.dart';

Widget semanticCameraButton({child}) {
  return Semantics(
    child: child,
    button: true,
    enabled: true,
    label: "Take photo",
    onTapHint: "Take a photo"
  );
}

Widget semanticUploadButton({child}) {
  return Semantics(
    child: child,
    button: true,
    enabled: true,
    label: "Upload Post",
    onTapHint: "Photo uploaded"
  );
}

Widget semanticWasteImage({child}) {
  return Semantics(
    child: child,
    image: true,
    label: "Food Waste Image",
  );
}

Widget semanticQuantityForm({child}) {
  return Semantics(
    child: child,
    textField: true,
    focusable: true,
    label: "Waste Item Quantity",
    hint: "Enter a quantity"
  );
}

Widget semanticPost({child}) {
  return Semantics(
    child: child,
    button: true,
    onLongPressHint: "Delete Post",
    onTapHint: "Post details",
    label: "Waste Item Post",
  );
}


Widget semanticLoading({child}) {
  return Semantics(
    child: child,
    label: "Loading",
  );
}

Widget semanticHeader({child}) {
  return Semantics(
    child: child,
    header: true,
  );
}

Widget semanticLocation({child}) {
  return Semantics(
    child: child,
    onTapHint: "Location (latitude, longitude)"
  );
}
