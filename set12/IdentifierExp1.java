import java.util.Map;
//Constructor template for IdentifierExp1:
//new IdentifierExp1(name);
//INTERPRETATION:
//name is of type String which specifies the name of this identifier

public class IdentifierExp1 extends Exp1 implements IdentifierExp {

	private String name; // specifies the name of the identifier

	IdentifierExp1() // non parameterized constructor
	{

	}

	IdentifierExp1(String s) // parameterized constructor
	{

		this.name = s;
	}

	//------------------------------------------------------------------------------------------------
	//                         MEMBER FUNCTIONS
	//-------------------------------------------------------------------------------------------------

	@Override

	// RETURNS: a boolean value that is true or false, as the function is called on 
	//          a IdentifierExp object,the function returns true
	// EXAMPLE: Asts.identifierExp ("n").isIdentifier() = true
	public boolean isIdentifier()
	{
		return true;
	}

	//-----------------------------------------------------------------------------------------------

	@Override

	// RETURNS: an IdentifierExp object, the representation of the identifier expression
	//          object is returned
	// EXAMPLE: obj.asIdentifier() = obj
	//          obj is an identifier expression object 
	public IdentifierExp asIdentifier()
	{
		return this;
	}

	//---------------------------------------------------------------------------------------------

	// RETURNS: the name of this identifier of the identifier expression object.
	// EXAMPLE: Asts.identifierExp ("n").name() = n 
	public String name(){
		return this.name;
	}

	//--------------------------------------------------------------------------------------------

	// GIVEN: a Map<String,ExpVal>, which is the environment for a Identifier expression
	// RETURNS: a ExpVal, which returns the identifier name and throws an exception if the particular 
	//          name does not exist in the key of the map a null pointer exception is thrown
	public ExpVal value (Map<String,ExpVal> env)
	{
		ExpVal e = new ExpVal1();

		try
		{

			e = env.get(this.name);

		}
		catch(NullPointerException n)
		{
			System.out.println("Identifier Expression : Warning : Variable of this expression is not a key of the given Map");	
		}
		catch(Exception e1)
		{
			System.out.println("Warning: Exception thrown!");
		}
		
			return e;
		
	}

}
