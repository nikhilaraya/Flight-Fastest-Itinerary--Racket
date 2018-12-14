// Returns the alternating sum of the first n squares, computed ITERS times.
//
// Result is
//
//     n*n - (n-1)*(n-1) + (n-2)*(n-2) - (n-3)*(n-3) + ...
//
// Usage:
//
//     java Sumsq N ITERS

class Sumsq2 {

    public static void main (String[] args) {
        long n = Long.parseLong (args[0]);
        long iters = Long.parseLong (args[1]);
        System.out.println (mainLoop (n, iters));
    }

    // Modify this method to use loop syntax instead of tail recursion.

    static long mainLoop (long n, long iters) {
    	while(iters>=0)
    	{
    	if(iters == 1)
    	{
    		return sumSquares(n);
    	}
    	else if (iters == 0)
            return -1;
        else
        {
            iters=iters-1;
            sumSquares(n);
        }
    	}
    	return 0;
    }

    // Returns alternating sum of the first n squares.

    static long sumSquares (long n) {
        return sumSquaresLoop (n, 0);
    }

    // Modify the following methods to use loop syntax
    // instead of tail recursion.

    // Returns alternating sum of the first n+1 squares, plus sum.

    static long sumSquaresLoop (long n, long sum) {
    	long totalSum=0;
        if (n < 0)
            return (n*n);
        else 
        	{
        	totalSum=sumSquaresLoop2 (n , 0);
        	return totalSum;
        	}
    }

    // Returns alternating sum of the first n+1 squares,
    // minus (n+1)^2, plus sum.

    static long sumSquaresLoop2 (long n, long sum) {
    	if(n>=0)
    	{	
        boolean temp=true;
        long nextN= n+1;
        long totalSum=0;
        long finalComputedSum=0;
        
        while(n>=0)
        {
        	if(temp)
        	{
        		temp=false;
        		totalSum=totalSum+(n*n);      		
        	}
        	else if(!temp)
        	{
        		temp=true;
        		totalSum=totalSum-(n*n);
        	}
        	n=n-1;
        }
        finalComputedSum = 0-(totalSum-(nextN*nextN)+sum);
        return finalComputedSum;
        }
    	else
    	{
    		return sum-(n*n);
    	}
    }
}
