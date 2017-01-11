//+------------------------------------------------------------------+
//|                                                     HumbleMA.mq4 |
//|                                        Copyright 2016, Humble AI |
//|                                          http://www.humbleai.com |
//+------------------------------------------------------------------+
#property copyright   "2016, Humble AI"
#property link        "http://www.humbleai.com"
#property description "Humble MA"

#property strict

#property indicator_chart_window

#property indicator_buffers 8

#property indicator_color1 PeachPuff
#property indicator_color2 PowderBlue
#property indicator_color3 LightPink
#property indicator_color4 DeepSkyBlue
#property indicator_color5 PeachPuff
#property indicator_color6 PowderBlue
#property indicator_color7 DodgerBlue
#property indicator_color8 DodgerBlue

#property indicator_width1 1
#property indicator_width2 1
#property indicator_width3 1
#property indicator_width4 1
#property indicator_width5 1
#property indicator_width6 1
#property indicator_width7 2
#property indicator_width8 2

//--- indicator parameters

input int            InpPricePeriod = 1440;        // Price Period
input int            PriceMode = 3;                // 0: Close, 1: High, 2: Low, 3: Typical, 4: Median
input int            CalcMode = 1;                 // 1: Pips, 2: Percentage
input double         PipRange = 0.0025;            // 25 Pips / Pips Mode
input double         Percentage = 25;              // 25 percent of H-L / Percentage Mode

//--- indicator buffers
double PriceExtLineBuffer[];
double PriceHExtLineBuffer[];
double PriceLExtLineBuffer[];

double LevelLine1[];
double LevelLine2[];
double LevelLine3[];
double LevelLine4[];
double LevelLine5[];
double LevelLine6[];


//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int OnInit(void)
  {

   IndicatorShortName("Humble Ranges");
   
   IndicatorBuffers(9);
   
   
   SetIndexStyle(0, DRAW_HISTOGRAM,STYLE_DOT);
   SetIndexBuffer(0, LevelLine1);
   
   SetIndexStyle(1, DRAW_HISTOGRAM,STYLE_DOT);
   SetIndexBuffer(1, LevelLine2);
   
   SetIndexStyle(2, DRAW_HISTOGRAM,STYLE_DOT);
   SetIndexBuffer(2, LevelLine3);
   
   SetIndexStyle(3, DRAW_HISTOGRAM,STYLE_DOT);
   SetIndexBuffer(3, LevelLine4);
   
   SetIndexStyle(4, DRAW_HISTOGRAM,STYLE_DOT);
   SetIndexBuffer(4, LevelLine5);
   
   SetIndexStyle(5, DRAW_HISTOGRAM,STYLE_DOT);
   SetIndexBuffer(5, LevelLine6);
   
   SetIndexStyle(6, DRAW_LINE);
   SetIndexBuffer(6, PriceHExtLineBuffer);
   
   SetIndexStyle(7, DRAW_LINE);
   SetIndexBuffer(7, PriceLExtLineBuffer);
   
   SetIndexBuffer(8, PriceExtLineBuffer);

   return(INIT_SUCCEEDED);
  }
  
  
void start()
  {
   int i, Counted_bars; 
//--------------------------------------------------------------------
   Counted_bars = IndicatorCounted(); // Number of counted bars
   i=Bars-Counted_bars-1;           // Index of the first uncounted
   int HighIndex, LowIndex;         // Prev HL positions
   double FactorValue;
   
   switch(PriceMode) 
     {   
      case 0 : PriceExtLineBuffer[0] = Close[0];      break;
      case 1 : PriceExtLineBuffer[0] = High[0];    break;
      case 2 : PriceExtLineBuffer[0] = Low[0];  break;
      case 3 : PriceExtLineBuffer[0] = (High[0] + Low[0] + Close[0]) / 3;   break;
      case 4 : PriceExtLineBuffer[0] = (High[0] + Low[0]) / 2;   break;
      default: PriceExtLineBuffer[0] = Close[0]; 
     }      

   while(i>=0)                      // Loop for uncounted bars
     {
      HighIndex = iHighest(NULL, 0, MODE_HIGH, InpPricePeriod, i);
      LowIndex = iLowest(NULL, 0, MODE_LOW, InpPricePeriod, i);
      
      double highestp = High[HighIndex];
      double lowestp = Low[LowIndex];
      double currentp;

      switch(PriceMode) 
        {   
         case 0 : currentp = Close[i];      break;
         case 1 : currentp = High[i];    break;
         case 2 : currentp = Low[i];  break;
         case 3 : currentp = (High[i] + Low[i] + Close[i]) / 3;   break;
         case 4 : currentp = (High[i] + Low[i]) / 2;   break;
         default: currentp = Close[i]; 
        }      
      
      
      PriceExtLineBuffer[i] = MathAbs(currentp - lowestp) * 100 / (MathAbs(highestp - currentp) + MathAbs(currentp - lowestp));
      
      PriceHExtLineBuffer[i] = highestp;
      PriceLExtLineBuffer[i] = lowestp;
      if (CalcMode == 1) FactorValue = PipRange; else FactorValue = (highestp  - lowestp) / 100 * Percentage;
      
      if (HighIndex > LowIndex) 
      {
         // highesttan aşağı
         LevelLine1[i] = highestp - FactorValue;
         LevelLine2[i] = highestp - FactorValue * 2;
         LevelLine3[i] = highestp - FactorValue * 3;
         LevelLine4[i] = highestp - FactorValue * 4;
         LevelLine5[i] = highestp - FactorValue * 5;
         LevelLine6[i] = highestp - FactorValue * 6;
         
         
      } else 
      { 
         // lowesttan yukarı
         LevelLine1[i] = lowestp + FactorValue;
         LevelLine2[i] = lowestp + FactorValue * 2;
         LevelLine3[i] = lowestp + FactorValue * 3;
         LevelLine4[i] = lowestp + FactorValue * 4;
         LevelLine5[i] = lowestp + FactorValue * 5;
         LevelLine6[i] = lowestp + FactorValue * 6;
      }

      
     
      
      i--;
     }
    
   return;
  }

