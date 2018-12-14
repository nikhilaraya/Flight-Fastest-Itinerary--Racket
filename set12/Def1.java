// Constructor template for Def1:
//        new Def1(left,right);
// INTERPRETATION:
// left is of type String and specifies the left hand side of the definition 
//      which is an identifier represented as a String.
// right is of type Exp and specifies the  right hand side of this definition,
//       which will be a ConstantExp or a LambdaExp.

public class Def1 extends Ast1 implements Def  {
	
	  private String left; // specifies the left hand side of the definition
	  private Exp right; // specifies the right hand side of the definition
	  Def1() // non parameterized constructor
	  {
		  this.left = null; // assigning left of this object to null initially
		  this.right = null; // assigning right of this object to null initially
	  }
	  
	  Def1 (String l, Exp e ) // parameterized constructor
	  {
		  
		  this.left = l;  // assigning l to left of this object
		  this.right = e; // assigning e to the right of this object
	  }
	  
	  //-----------------------------------------------------------------------------------------
	  
	  @Overidden
	  
	// RETURNS: a boolean value that is true or false, as the function is called on 
	//          a definition(Def1) object,the function returns true
	// EXAMPLE: obj.isDef() = true
	//          where obj is a Def object
	  
	  public boolean isDef()
	  {
		  return true;
	  }
	  
	  //---------------------------------------------------------------------------------------
	  
	  @Override
	  
	// RETURNS: a Def object, the representation of the definition
	//          object is returned
	// EXAMPLE: obj.asDef() = obj
	//          obj is an Def object

	  public Def asDef() {
		  return this;
	  }
	  
	  //---------------------------------------------------------------------------------------------
	  
	  
	// RETURNS : the left hand side of this definition,
	//           which will be an identifier represented as a String.
	// EXAMPLE: Def def1
	//                  = Asts.def ("fact",
	//                             Asts.lambdaExp (Asts.list ("n"),
	//                                             Asts.ifExp (testPart,
	//                                                         thenPart,
	//                                                         elsePart)));
    //         def1.lhs() = fact
	  
	  
    public String lhs()
    {
    	return this.left;
    }
    
    //-----------------------------------------------------------------------------------------


    // RETURNS: the right hand side of this definition,
    // which will be a ConstantExp or a LambdaExp.
    // EXAMPLE: Def def1
    //                  = Asts.def ("fact",
    //                             Asts.lambdaExp (Asts.list ("n"),
    //                                             Asts.ifExp (testPart,
    //                                                         thenPart,
    //                                                         elsePart)));
	//         def1.rhs() = Asts.lambdaExp (Asts.list ("n"),
    //                                             Asts.ifExp (testPart,
    //                                                         thenPart,
    //                                                         elsePart)));
    public Exp rhs()
    {
    	return this.right;
    }

}
