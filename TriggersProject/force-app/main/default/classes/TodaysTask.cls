public class TodaysTask {
    public TodaysTask(){
        takeShower();
        eatBreakfast();
        carService();
        movieWithGf();		
        
    }
    
    public static void takeShower(){
        System.debug('Taking Showrr');
    }
    
    public static void eatBreakfast(){
        System.debug('Eating Breakfast');
    }
    
    @future
    public static void carService(){
        System.debug('Car is Servicing');
    }
    
    public static void movieWithGf(){
        System.debug('Movie with Gf');
    }

}