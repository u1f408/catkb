use serde::{Serialize, Deserialize};
use rxing::{self, Writer, MultiFormatWriter};

use crate::BarcodeFormat;

#[derive(Serialize, Deserialize, Debug)]
pub struct EncodeResponse {
    pub request_id: String,
    pub encoded_data: String,
}

#[derive(Serialize, Deserialize, Debug)]
pub struct EncodeRequest {
    pub request_id: String,
    pub data: String,
    pub format: BarcodeFormat,
    pub width: Option<i32>,
    pub height: Option<i32>,
}

impl EncodeRequest {
    pub fn process(&self) -> Result<EncodeResponse, anyhow::Error> {
        let writer: MultiFormatWriter = Default::default();
        let format = self.format.clone().to_rxing();
        let width = self.width.unwrap_or(24);
        let height = self.height.unwrap_or(width);

        let result = writer.encode(&self.data, &format, width, height)?;
        Ok(EncodeResponse {
            request_id: self.request_id.clone(),
            encoded_data: svg::Document::from(&result).to_string(),
        })
    }
}
