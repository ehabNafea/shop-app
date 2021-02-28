import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/constants.dart';
import 'package:shop_app/providers/product.dart';
import 'package:shop_app/providers/products.dart';
import 'package:shop_app/widget/default_btn.dart';

class EditProduct extends StatefulWidget {
  static const routeName = 'edit-product';
  @override
  _EditProductState createState() => _EditProductState();
}

class _EditProductState extends State<EditProduct> {
  final _priceFocusNode = FocusNode();
  final _desFocusNode = FocusNode();
  final _imageUrlController = TextEditingController();
  final _imageFocusNode = FocusNode();
  final _form = GlobalKey<FormState>();
  var _editingProduct = Product(
    id: null,
    title: '',
    description: '',
    price: 0.0,
    imageUrl: '',
  );
  bool _init = true;
  bool _isLoading = false;
  var _initValues = {
    'title': '',
    'price': '',
    'description' : '',
    'imageUrl' : ''
  };

  @override
  void initState() {
    _imageFocusNode.addListener(_updateImageUrl);
    super.initState();
  }

  @override
  void dispose() {
    _priceFocusNode.dispose();
    _desFocusNode.dispose();
    _imageUrlController.dispose();
    _imageFocusNode.removeListener(_updateImageUrl);
    super.dispose();
  }

  void _updateImageUrl() {
    if (!_imageFocusNode.hasFocus) {
      // if ((!_imageUrlController.text.startsWith('http') &&
      //         !_imageUrlController.text.startsWith('https')) ||
      //     (!_imageUrlController.text.endsWith('.jpg') &&
      //         !_imageUrlController.text.endsWith('.png') &&
      //         !_imageUrlController.text.endsWith('.jpeg'))) {
      //   return;
      // }
      setState(() {});
    }
  }

  Future<void> _saveProduct() async {
    if (_form.currentState.validate()) {
      _form.currentState.save();
      setState(() {
        _isLoading = true;
      });
      if(_editingProduct.id != null){
        await Provider.of<Products>(context, listen: false).updateProduct(_editingProduct.id, _editingProduct);

      }else{

        try{
          await Provider.of<Products>(context, listen: false).addProduct(_editingProduct);
        } catch (error) {
         await showDialog(context: context, builder: (ctx) => AlertDialog(
            title: Text('An Error'),
            content: Text('Something went wrong'),
            actions: [
              FlatButton(
                onPressed: () { Navigator.pop(ctx); },
                child: Text('Okay'),
              ),
            ],
          ));
        }
        // finally {
        //   setState(() {
        //     _isLoading = false;
        //   });
        //   Navigator.pop(context);
        // }
      }
    }
      setState(() {
        _isLoading = false;
      });
      Navigator.pop(context);
  }

  @override
  void didChangeDependencies() {
    if(_init){
      final productID = ModalRoute.of(context).settings.arguments as String;
      if(productID != null){
        _editingProduct = Provider.of<Products>(context).findProductById(productID);
        _initValues = {
          'title': _editingProduct.title,
          'price': _editingProduct.price.toString(),
          'description' : _editingProduct.description,
          'imageUrl' : '',
        };
        _imageUrlController.text = _editingProduct.imageUrl;
      }

    }
  _init = false;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Product'),
      ),
      body:_isLoading  ? Center(
        child: CircularProgressIndicator(),
      ) : Padding(
        padding: const EdgeInsets.all(10.0),
        child: Form(
          key: _form,
          child: ListView(
            children: [
              TextFormField(
                initialValue: _initValues['title'],
                decoration: InputDecoration(
                  labelText: 'Title',
                ),
                textInputAction: TextInputAction.next,
                onFieldSubmitted: (_) {
                  FocusScope.of(context).requestFocus(_priceFocusNode);
                },
                validator: (value) {
                  if (value.isEmpty) {
                    return 'Please Enter title of the product';
                  }
                  return null;
                },
                onSaved: (value) {
                  _editingProduct = Product(
                    id: _editingProduct.id,
                    title: value,
                    description: _editingProduct.description,
                    price: _editingProduct.price,
                    imageUrl: _editingProduct.imageUrl,
                    isFavourite: _editingProduct.isFavourite

                  );
                },
              ),
              SizedBox(
                height: 10.0,
              ),
              TextFormField(
                initialValue: _initValues['price'],
                decoration: InputDecoration(
                  labelText: 'price',
                ),
                textInputAction: TextInputAction.next,
                keyboardType: TextInputType.number,
                focusNode: _priceFocusNode,
                onFieldSubmitted: (_) {
                  FocusScope.of(context).requestFocus(_desFocusNode);
                },
                validator: (value) {
                  if (value.isEmpty) {
                    return 'Please enter price';
                  }
                  if (double.tryParse(value) == null) {
                    return 'Please enter a valid number';
                  }
                  if (double.parse(value) <= 0) {
                    return 'Please enter number greater than Zero';
                  }
                  return null;
                },
                onSaved: (value) {
                  _editingProduct = Product(
                    id: _editingProduct.id,
                    title: _editingProduct.title,
                    description: _editingProduct.description,
                    price: double.parse(value),
                     imageUrl: _editingProduct.imageUrl,
                      isFavourite: _editingProduct.isFavourite
                  );
                },
              ),
              SizedBox(
                height: 10.0,
              ),
              TextFormField(
                initialValue: _initValues['description'],
                decoration: InputDecoration(
                  labelText: 'Description',
                ),
                keyboardType: TextInputType.multiline,
                focusNode: _desFocusNode,
                maxLines: 3,
                onSaved: (value) {
                  _editingProduct = Product(
                    id: _editingProduct.id,
                    title: _editingProduct.title,
                    description: value,
                    price: _editingProduct.price,
                    imageUrl: _editingProduct.imageUrl,
                      isFavourite: _editingProduct.isFavourite

                  );
                },
                validator: (value) {
                  if (value.isEmpty) {
                    return 'Please enter a description';
                  }
                  if (value.length < 10) {
                    return 'Description should be at least 10 characters Long';
                  }
                  return null;
                },
              ),
              SizedBox(
                height: 15.0,
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Container(
                    width: 100.0,
                    height: 100.0,
                    decoration: BoxDecoration(
                      border: Border.all(width: 1, color: Colors.grey),
                    ),
                    child: _imageUrlController.text.isEmpty
                        ? Center(
                            child: Text(
                            'Enter Url',
                          ))
                        : FittedBox(
                            child: Image.asset(
                              _imageUrlController.text,
                              fit: BoxFit.cover,
                            ),
                          ),
                  ),
                  SizedBox(
                    width: 10.0,
                  ),
                  Expanded(
                    child: TextFormField(
                      decoration: InputDecoration(
                        labelText: 'Image Url',
                      ),
                      keyboardType: TextInputType.url,
                      textInputAction: TextInputAction.done,
                      controller: _imageUrlController,
                      focusNode: _imageFocusNode,
                      onSaved: (value) {
                        _editingProduct = Product(
                          id: _editingProduct.id,
                          title: _editingProduct.title,
                          description: _editingProduct.description,
                          price: _editingProduct.price,
                          imageUrl: value,
                            isFavourite: _editingProduct.isFavourite

                        );
                      },
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Please enter image Url';
                        }
                        // if (!value.startsWith('http') &&
                        //     !value.startsWith('https')) {
                        //   return 'Please enter valid image url';
                        // }
                        if (!value.endsWith('.jpg') &&
                            !value.endsWith('.png') &&
                            !value.endsWith('.jpeg')) {
                          return 'Please enter valid image url';
                        }
                        return null;
                      },
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 20.0,
              ),
              DefaultBtn(
                onTap: () {
                  _saveProduct();
                },
                text: 'Save',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
