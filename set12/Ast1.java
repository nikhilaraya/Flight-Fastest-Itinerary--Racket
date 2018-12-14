import java.util.List;
//Constructor template for Ast1:
//new Ast1(pgmVar,d,e);
//INTERPRETATION:
//pgmVar is a lift of type Def which specifies a program which is a list of definitions
//d is of type Def which is a defination
//e is of typeExp which specifies an expression


public class Ast1 implements Ast{
	
	
	List<Def> pgmVar; // a list of definitions of an Ast1
	
	
	Ast1() //non parameterized constructor
	{
		
	}
	
	Ast1(List<Def> p) //a parameterized constructor creating an Ast1 when an Ast1 is a list of definitions
	{
		this.pgmVar = p;
	}
	
	
	//--------------------------------------------------------------------------------------------
	//                     MEMBER FUNCTIONS
	//--------------------------------------------------------------------------------------------
	
	// RETURNS: true iff this Ast is for a program else returns false
	// EXAMPLE: List<Def> pg = new ArrayList<Def>();
	//          Def def1
	//                  = Asts.def ("fact",
	//                               Asts.lambdaExp (Asts.list ("n"),
	//                                               Asts.ifExp (testPart,
	//                                                           thenPart,
	//                                                           elsePart)));
	//         pg.add(def1);
	//         obj.pg.isPgm() = true
	// DESIGN STRATEGY: Breaking down into cases

	public boolean isPgm() {
		
		if (this.pgmVar instanceof List)
		{
			return true;
		}
		else return false;
	}
	
	//------------------------------------------------------------------------------------
	
	
	// RETURNS: true iff this Ast is for a definition else returns false
	// EXAMPLE: Def def1
	//                  = Asts.def ("fact",
	//                               Asts.lambdaExp (Asts.list ("n"),
	//                                               Asts.ifExp (testPart,
	//                                                           thenPart,
	//                                                           elsePart)));
	//          obj.def1.isDef() = true
	// DESIGN STRATEGY: Breaking down into cases

	public boolean isDef() {
		return false;	
		}
	
	//--------------------------------------------------------------------------------------
	
	// RETURNS: true iff this Ast is for an expression else returns false
	// EXAMPLE: Exp exp
	//          = Asts.constantExp (Asts.expVal (1));
	//          this.exp.isExp() = true
	// DESIGN STRATEGY: Breaking down into cases

	public boolean isExp() {
		
			return false;
	}
	
	//------------------------------------------------------------------------------------------

	// RETURNS: a representation of that program,that is,List<Def>.
	// EXAMPLES: obj.asPgm() = obj
	//           obj is a List<Def>
	public List<Def> asPgm() {
		return this.pgmVar;
		
	}
	
	//-----------------------------------------------------------------------------------------
	
	// RETURNS: a representation of that definition.
	// EXAMPLES: obj.asDef() = obj
	//           obj is a Def

	public Def asDef() {
		
		return null;
	}
	
	//-------------------------------------------------------------------------------------------
	
	// RETURNS: a representation of that expression.
	// EXAMPLES: obj.asExp() = obj
	//           obj is a Exp

	public Exp asExp() {
		
		return null;
	}
	
	//-----------------------------------------------------------------------------------------------

}
