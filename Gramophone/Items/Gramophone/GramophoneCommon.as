
class GramophoneRecord
{
	string name;
	string filename;

	GramophoneRecord(string name, string filename)
	{
		this.name = name;
		this.filename = filename;
	}
};

const GramophoneRecord@[] records =
{
	GramophoneRecord("Mountain King", "Disc_MountainKing.ogg"),//0
	GramophoneRecord("Liberty Bell March", "Disc_LibertyBellMarch.ogg"),//1
	GramophoneRecord("It is a Mystery", "Disc_Mystery.ogg"),//2
	GramophoneRecord("No Hushing", "Disc_NoHushing.ogg"),//3
	GramophoneRecord("Sacred War", "Disc_SacredWar.ogg"),//4
	GramophoneRecord("Drunken Sailor", "Disc_DrunkenSailor.ogg"),//5
	GramophoneRecord("Viva Las Vegas", "Disc_VivaLasVegas.ogg"),//6
	GramophoneRecord("Odd Couple", "Disc_OddCouple.ogg"),//7
	GramophoneRecord("Bandit Radio", "Disc_Bandit.ogg"),//8
	GramophoneRecord("Tea for Two", "Disc_TeaForTwo.ogg"),//9
	GramophoneRecord("Marty Robbins - Big Iron", "Disc_BigIron.ogg"),//10
	GramophoneRecord("Creedence Clearwater - Fortunate Son", "Disc_FortunateSon.ogg"),//11
	GramophoneRecord("Money", "Disc_Money.ogg"),//12
	GramophoneRecord("Homeward Bound", "Disc_HomewardBound.ogg"),//13
	GramophoneRecord("Was wollen wir trinken", "Disc_LuftwaffeAnthem.ogg"),//14
	GramophoneRecord("Luftwaffe March", "Disc_LuftwaffeMarch.ogg"),//15
	GramophoneRecord("Марш речников - March of Rivermen | Leonid Kostritsa", "Disc_March_Rechnikov-March_of_Rivermen.ogg"),//16
	GramophoneRecord("Потому, потому что мы пилоты - Because we are pilots | Leonid Kostritsa", "Disc_Potomu_chto_mi_-_piloti-Because_we_are_-_pilots.ogg"),//17
	GramophoneRecord("Вернулся я на родину - I'm back to my homeland | Leonid Kostritsa", "Disc_Vernuls'a_ya_na_rodinu-Returned_to_my_homeland.ogg"),//18
	GramophoneRecord("Johny", "Disc_Johny.ogg"),//19
	GramophoneRecord("Pirate Tavern", "Disc_PirateTavern.ogg"),//20
	GramophoneRecord("Wo Alle Strassen Enden", "Disc_WoAlleStrassenEnden.ogg"),//21
	GramophoneRecord("Arbeiter, Bauern, nehmt die Gewehre", "Disc_ArbeiterBauernnehmtdieGewehr.ogg"),//22
	GramophoneRecord("Chip 'n Dale 2 Western World by Intender", "Disc_Chip'nDaleWesternWorld.ogg"),//23
	GramophoneRecord("FFVI Devil's Lab by Chronamut", "Disc_DevilsLab.ogg"),//24
	GramophoneRecord("Moyuru ōzora - Burning sky", "Disc_MoyuruOzora.ogg"),//25
	GramophoneRecord("VC1 Against The Odds", "Disc_AgainstTheOdds.ogg"),//26
	GramophoneRecord("Kitasakaba", "Disc_Kitasakaba.ogg"),//27
	GramophoneRecord("J'aime L'oignon", "Disc_JaimeLoignon.ogg"),//28
	GramophoneRecord("A Stranger I Remain", "A_Stranger_I_Remain.ogg"),// 29
	GramophoneRecord("Collective Consciouness", "Collective_Consciouness.ogg"),//30
	GramophoneRecord("It Has To Be This Way", "It_Has_To_Be_This_Way.ogg"),// 31
	GramophoneRecord("The Only Thing I Know For Real", "The_Only_Thing_I_Know_For_Real.ogg"),// 32
	GramophoneRecord("Battotai - Imperial Japanese Army March", "Disc_Battotai.ogg"),// 33
	GramophoneRecord("Paul Engemann - Push It To The Limit (Scarface)", "Disc_PushToTheLimit.ogg"),// 34
	GramophoneRecord("Bella Ciao", "Disc_BellaCiao.ogg"),// 35
	GramophoneRecord("Warszawianka", "Disc_Warszawianka.ogg"),// 36
	GramophoneRecord("Famous Opera", "Disc_Opera.ogg"),// 37
	GramophoneRecord("II Magnifico Cornuto (M11)", "Disc_II-Magnifico-Cornuto(M11).ogg"),// 38
	GramophoneRecord("Circus Ambience", "Disc_CircusMusic.ogg"),// 39
	GramophoneRecord("Kalambur", "Disc_Kalambur.ogg"),// 40
	GramophoneRecord("Heaven Pierce Her - Versus", "Disc_Versus.ogg"),// 41
	GramophoneRecord("Heaven Pierce Her - ORDER", "Disc_Order.ogg")// 42
};
// type !disc NUMBER_OF_TRACK_FROM_LIST_ABOVE
// example: !disc 0 will give you mountain king