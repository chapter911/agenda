import 'package:flutter/material.dart';

class Style {
  String hint = "";
  Icon? icon;
  IconButton? suffixIcon;
  Color warna = Colors.redAccent;
  InputDecoration dekorasiInput({hint, icon, suffixIcon}) {
    return InputDecoration(
      hintText: hint,
      label: Text(hint),
      prefixIcon: icon,
      suffixIcon: suffixIcon,
      filled: true,
      contentPadding: const EdgeInsets.symmetric(vertical: 15, horizontal: 10),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(
          color: Colors.black12,
          width: .5,
        ),
      ),
    );
  }

  BoxDecoration dekorasiDropdown() {
    return BoxDecoration(
      color: Colors.redAccent,
      borderRadius: BorderRadius.circular(10),
      border: Border.all(
        color: Colors.black,
        width: .5,
      ),
    );
  }

  BoxDecoration dekorasiFoto() {
    return const BoxDecoration(
      color: Colors.redAccent,
      borderRadius: BorderRadius.all(
        Radius.circular(10),
      ),
    );
  }

  BoxDecoration dekorasiIconButton({warna}) {
    return BoxDecoration(
      color: warna ?? Colors.redAccent,
      borderRadius: const BorderRadius.all(
        Radius.circular(10),
      ),
    );
  }
}
