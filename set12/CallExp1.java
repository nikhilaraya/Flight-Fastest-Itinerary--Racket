import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

//Constructor template for CallExp1:
//new CallExp1(op1,arg);
//INTERPRETATION:
//op1 is of type Exp and specifies the expression for the function part of the call
//arg is a List which specifies the list of argument expressions



public class CallExp1 extends Exp1 implements CallExp 
{
	private Exp op1;
	private List<Exp> arg;

	CallExp1() // non parameterized constructor
	{

	}

	CallExp1( Exp o, List<Exp> a) // parameterized constructor
	{
		this.op1 = o;
		this.arg = a;

	}

	//----------------------------------------------------------------------------------------
	//                     MEMBER FUNCTIONS
	//----------------------------------------------------------------------------------------

	@Override

	// RETURNS: a boolean value that is true or false, as the function is called on 
	//          an call expression object,the function returns true
	// EXAMPLE: obj.isCall() = true
	//          where obj is an call expression object

	public boolean isCall()
	{
		return true;
	}

	//--------------------------------------------------------------------------------------------

	@Override

	// RETURNS: an CallExp object, the representation of the call expression
	//          object is returned
	// EXAMPLE: obj.asCall() = obj
	//          obj is an call expression object

	public CallExp asCall()
	{
		return this;
	}

	//----------------------------------------------------------------------------------------------

	// RETURNS: the expression for the function part of the call.
	// EXAMPLE:  Asts.callExp (Asts.identifierExp ("fact"),
	//                                       Asts.list (exp1)).operator() = 
	//                                         Asts.identifierExp ("fact");

	public Exp operator()

	{
		return this.op1;

	}

	//----------------------------------------------------------------------------------------------

	// RETURNS: the list of argument expressions
	// EXAMPLE: Asts.callExp (Asts.identifierExp ("fact"),
	//                                       Asts.list (exp1)).arguments() = 
	//                                         Asts.list (exp1)

	public List<Exp> arguments()
	{
		return this.arg;
	}

	//------------------------------------------------------------------------------------------------

	@Overidden

	public ExpVal value (Map<String,ExpVal> env)
	{
		 

		ExpVal eidentity = new FunVal1();
		ExpVal eLambda = new ExpVal1();
		ExpVal result = new ExpVal1();
		LambdaExp lam;
		FunVal f ;
		List<String> strings = new ArrayList<String>();
		List<Exp> expList;
		try
		{
			
			eidentity = this.op1.value(env);

			if(eidentity.isFunction())
			{

				f = eidentity.asFunction();

				lam = f.code();
				Map<String, ExpVal> fEnv = f.environment();
				
				
				strings = lam.formals();
				expList = this.arg;

				Map<String, ExpVal> neenv = new HashMap<String, ExpVal>(env);
				neenv.putAll(fEnv);

				for(int i =0 ;i <strings.size(); i++)
				{
					neenv.put(strings.get(i), expList.get(i).value(env));
				}
				
				

				result = lam.body().value(neenv);
			}

		}
		catch(NullPointerException n)
		{
			System.out.println("Call Expression : Warning : Variable of this expression is not a key of the given Map");	
		}
		
		return result;
	}
	//----------------------------------------------------------------------------------------------

}
