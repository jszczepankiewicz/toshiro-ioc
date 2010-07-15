package org.toshiroioc.test.beans
{
	public class I18NBeanWrongType
	{
		private var _translatedField:Object;
		private var _translatedField2:String;
		private var _notTranslatedField:String;
		private var _simpleRef:SimpleBean;
		
		[i18n]
		public function set translatedField(value:Object):void{
			_translatedField = value;
		}
		public function get translatedField():Object{
			return _translatedField;
		}
		[i18n]
		public function set translatedField2(value:String):void{
			_translatedField2 = value;
		}
		public function get translatedField2():String{
			return _translatedField2;
		}
		public function set notTranslatedField(value:String):void{
			_notTranslatedField = value;
		}
		public function get notTranslatedField():String{
			return _notTranslatedField;
		}
		public function set simpleBean(value:SimpleBean):void{
			_simpleRef = value;
		}
		public function get simpleBean():SimpleBean{
			return _simpleRef;
		}
	}
}