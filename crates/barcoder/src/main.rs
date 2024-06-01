use serde::{Serialize, Deserialize};
use rxing::BarcodeFormat as RxingBarcodeFormat;
use std::io::{self, BufRead};
use anyhow::{self, Context};

mod encode;
use self::encode::{EncodeRequest, EncodeResponse};

#[derive(Serialize, Deserialize, Debug, Clone)]
#[serde(rename_all = "lowercase")]
pub enum BarcodeFormat {
    Aztec,
}

impl BarcodeFormat {
    pub fn to_rxing(self) -> RxingBarcodeFormat {
        match self {
            Self::Aztec => RxingBarcodeFormat::AZTEC,
        }
    }
}

#[derive(Serialize, Deserialize, Debug)]
#[serde(rename_all = "lowercase")]
pub enum Response {
    Encode(EncodeResponse),
}

#[derive(Serialize, Deserialize, Debug)]
#[serde(rename_all = "lowercase")]
pub enum Request {
    Encode(EncodeRequest),
}

impl Request {
    pub fn process(&self) -> Result<Response, anyhow::Error> {
        let res = match self {
            Self::Encode(r) => r.process().map(|e| Response::Encode(e)),
        };

        res.with_context(|| format!("while processing Request::{}", match self {
            Self::Encode(_) => "Encode",
        }))
    }
}

pub fn handle_line(line: String) -> Result<Response, anyhow::Error> {
    let req: Request = serde_json::from_str(&line)?;
    req.process()
}

pub fn main() -> Result<(), anyhow::Error> {
    let stdin = io::stdin();
    for line in stdin.lock().lines() {
        let resp = handle_line(line?)?;
        println!("{}", serde_json::to_string(&resp)?);
    }

    Ok(())
}
