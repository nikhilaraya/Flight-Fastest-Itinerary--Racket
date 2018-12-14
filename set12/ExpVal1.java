import java.util.*;

//Constructor template for ExpVal1:
//new ExpVal1(value);
//INTERPRETATION:
//value is of type either String or Boolean or Long or FunVal.
//The value specifies the value of the expression.

public class ExpVal1 implements ExpVal {
	
	
	private Boolean b; // specifies the value of the expression of Boolean type
	private Long t; // specifies the value of the expression of Long type
	private FunVal f; // specifies the value of the expression of FunVal type
	
	ExpVal1() // non parameterized constructor
	{
		
	}
	
	ExpVal1(boolean bInput) // parameterized constructor 
	{
		this.b = bInput; // assigning boolean bInput value to this object 
	}
	
	ExpVal1(long tInput) // parameterized constructor 
	{
		
		this.t= tInput; // assigning Long tInput value to this object 
		
	}
	
	ExpVal1(FunVal fInput) // parameterized constructor 
	{
		this.f = fInput; // assigning FunVal fInput value to this object
	}
	
	//-----------------------------------------------------------------------------------
	
	// RETURNS: true iff this ExpVal is of Boolean type else returns false
	// EXAMPLE: Asts.expVal(1).isBoolean() = false
	//          Asts.expVal("true").isBoolean() = true
	// DESIGN STRATEGY: Breaking down into cases
	
	public boolean isBoolean()
	{
		if (this.b instanceof Boolean)
			return true;
		else return false;
	}
	
	
	//---------------------------------------------------------------------------------------
	
	// RETURNS: true iff this ExpVal is of Integer type else returns false
	// EXAMPLE: Asts.expVal(1).isInteger() = true
	//          Asts.expVal("true").isInteger() = false
	// DESIGN STRATEGY: Breaking down into cases
	
	public boolean isInteger()
	{
		if(this.t instanceof Long)
			return true;
		else return false;
	}
	
	//------------------------------------------------------------------------------------------
	
	// RETURNS: true iff this ExpVal is of FunVal1 type else returns false
	public boolean isFunction()
	{
		if(this.f instanceof FunVal1)
			return true;
		else
			return false;
		
	}
	
	//--------------------------------------------------------------------------------------------
	
	// RETURNS: a boolean value,that is true or false, the representation of the 
	//          Boolean type is returned
	// EXAMPLE: obj.asBoolean() = true 
	//          where obj is an ExpVal object of value type boolean

	public boolean asBoolean() {
		return this.b;
		
	}
	
	//------------------------------------------------------------------------------------------
	
	// RETURNS: a integer value, the representation of the Integer type is returned
	// EXAMPLE: obj.asInteger() = 1
	//          where obj is an ExpVal object of value type Integer

	public long asInteger() {
		return this.t;
	}
	
	//-------------------------------------------------------------------------------------------
	
	// RETURNS: a FunVal value, the representation of the FunVal type is returned
	// EXAMPLE: obj.asFunction() = obj
	//          where obj is an ExpVal object of value type FunVal
	
	public FunVal asFunction() {
		return this.f;
	}
	
	//----------------------------------------------------------------------------------------------

}
