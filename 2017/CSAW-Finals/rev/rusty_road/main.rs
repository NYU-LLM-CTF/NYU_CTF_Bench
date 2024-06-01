use std::collections::HashMap;

fn get_path() -> String {
    use std::io::{stdin,stdout,Write};
    let mut s=String::new();
    println!("Enter your path: ");
    let _=stdout().flush();
    stdin().read_line(&mut s).expect("Did not enter a correct string");
    if let Some('\n')=s.chars().next_back() {
        s.pop();
    }
    if let Some('\r')=s.chars().next_back() {
        s.pop();
    }
    s
}

fn traverse(path: &mut String,maps:&mut HashMap<&char,Vec<Vec<u32>>> ) -> u32{
let mut x = 0;
let mut y = 0;
let mut path_sum = 2;
for i in path.chars(){
    assert!(maps.contains_key(&i), "YOU CAN'T GO THAT WAY??");
        if y < maps[&i].len() && x < maps[&i][0].len() {
            if i == 'U' as char {
                y +=1;
                }  
            else if i == 'R' as char {
                x+=1;
                }
            else if i == 'L' as char && x > 0{
                x-=1;
                }
            else if i == 'D' as char && y > 0{
                y -=1;
                }
            assert!(x <= 9 && y <=9, "YOU ARE STRETCHING THE LIMITS");
            path_sum += maps[&i][y][x];
        }
    }
    assert!([x,y] == [9,9], "YOU HAVEN'T REACHED THE END");
    path_sum
}

fn board_algo(n: usize) -> Vec<u32>{
    let mut bit_vec: Vec<u32> = vec![1;n];
    let mut primes: Vec<u32> = Vec::new();
    for i in 2..n{
        let mut start = i*i;
        while start < n {
            bit_vec[start-1] = 0;
            start += i;
        }   
    }
    for i in 2..n {
        if bit_vec[i-1] == 1{
            primes.push(i as u32);}
    }
    primes
}

fn win(){
    use std::fs::File;
    use std::io::prelude::*;
    
    println!("YOOOOOOOOOUUUUUUUUUU WIIIIIIIIIIIINNN");
    
    let mut file = File::open("flag.txt").expect("file not found");
    let mut contents = String::new();
    file.read_to_string(&mut contents);
    
    println!("{}", contents);
}

fn main(){
    let mut maps:HashMap<&char,Vec<Vec<u32>>> = HashMap::new();
    
    println!("CAN YOU FIND THE WAY!");
    let mut path = get_path();

    maps.insert(&'U',vec![Vec::new();10]);
    maps.insert(&'D',vec![Vec::new();10]);
    maps.insert(&'R',vec![Vec::new();10]);
    maps.insert(&'L',vec![Vec::new();10]);

    let prime_vec = board_algo(2750);
    let mut start = 0;
    let mut last = prime_vec.len() - 1;

    while start != last{
        for c in [&'U',&'D',&'R',&'L'].iter(){
            for i in 0..10{
                for _ in 0..5{
                    maps.get_mut(c).unwrap()[i].push(prime_vec[start]);
                    maps.get_mut(c).unwrap()[i].push(prime_vec[last]);
                    start+=1;
                    last-=1;
                }    
            } 
        }
    }
    for i in maps.values_mut(){i[0][0] = 2;}

    let smallest = 25132u32;
    let traversal = traverse(&mut path, &mut maps); 
    assert_eq!(smallest, traversal);
    win();
}
