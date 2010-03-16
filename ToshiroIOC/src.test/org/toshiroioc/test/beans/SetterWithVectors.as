package org.toshiroioc.test.beans{
	
	public class SetterWithVectors{
		private var booleanField:Boolean;
		private var simpleVectorField:Vector<Array>;
		private var objectsVectorField:Vector<Array>;

		public function set booleanItem(value:Boolean):void{
			booleanField = value;	
		}
		
		public function get booleanItem():Boolean{
			return booleanField;
		}
		
		public function set simpleVectorItem(value:Vector<Array>):void{
			simpleVectorField = value;
		}
		
		public function get simpleVectorItem():Vector<Array>{
			return simpleVectorField;
		}
		
		public function set objectsVectorItem(value:Vector<Array>):void{
			objectsVectorField = value;
		}
		
		public function get objectsVectorItem():Vector<Array>{
			return objectsVectorField;
		}
	}
}